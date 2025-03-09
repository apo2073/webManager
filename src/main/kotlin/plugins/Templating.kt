package kr.apo2073.plugins

import com.google.gson.JsonObject
import freemarker.cache.ClassTemplateLoader
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kr.apo2073.Main
import kr.apo2073.auth.Auth
import kr.apo2073.utilities.PlayerDetails
import kr.apo2073.utilities.getLog
import net.kyori.adventure.text.serializer.plain.PlainTextComponentSerializer
import org.bukkit.Bukkit
import java.util.*

private val main= Main.plugin
fun Application.configureTemplating() {
    install(FreeMarker) {
        templateLoader = ClassTemplateLoader(this::class.java.classLoader, "templates")
    }
    routing {
        val authCodes = mutableMapOf<String, String>()
        val pendingAuths = mutableMapOf<String, String>()

        suspend fun goToVerify(call: RoutingCall) {
            call.respond(FreeMarkerContent("auth.ftl", mapOf("error" to null, "code" to null), ""))
        }

        fun isAuthenticated(call: RoutingCall): Boolean {
            val encodedUuid = call.request.cookies["RQST_AUTH"] ?: return false
            return try {
                val uuid = String(Base64.getDecoder().decode(encodedUuid), Charsets.UTF_8)
                Bukkit.getPlayer(UUID.fromString(uuid))?.isOp == true
            } catch (e: IllegalArgumentException) {
//                call.application.log.error("Invalid UUID format in cookie: $encodedUuid")
                false
            }
        }

        post("/verify-code") {
            val code = call.receiveParameters()["code"]
            val uuid = authCodes[code]
            if (uuid != null) {
                pendingAuths[uuid] = "verified"
                authCodes.remove(code)
                call.respond(HttpStatusCode.OK, "Verification successful")
            } else {
                call.respond(HttpStatusCode.BadRequest, "Invalid code")
            }
        }

        post("/request-code") {
            val playerName = call.receiveParameters()["player"] ?: return@post call.respondRedirect("/")
            if (playerName.isEmpty()) {
                return@post call.respond(FreeMarkerContent("auth.ftl", mapOf("error" to "플레이어 이름을 입력하세요", "code" to null)))
            }

            val player = Bukkit.getPlayer(playerName) ?: return@post call.respond(
                FreeMarkerContent("auth.ftl", mapOf("error" to "존재하지 않는 플레이어입니다", "code" to null))
            )
            if (!player.isOp) {
                return@post call.respond(FreeMarkerContent("auth.ftl", mapOf("error" to "해당 플레이어는 관리자가 아닙니다!!", "code" to null)))
            }

            val uuid = player.uniqueId.toString()
            val authCode = Auth().generateAuthCode()
            authCodes[authCode] = uuid
            call.respond(FreeMarkerContent("auth.ftl", mapOf("error" to null, "code" to authCode)))
        }

        get("/check-auth") {
            val code = call.request.queryParameters["code"]
            val uuid = authCodes[code] ?: ""
            if (pendingAuths[uuid] == "verified") {
                call.response.cookies.append(
                    name = "RQST_AUTH",
                    value = Base64.getEncoder().encodeToString(uuid.toByteArray(Charsets.UTF_8)),
                    maxAge = 3600,
                    path = "/",
                    httpOnly = true
                )
                pendingAuths.remove(uuid)
                call.respondRedirect("/index")
            } else {
                call.respond(FreeMarkerContent("auth.ftl", mapOf("error" to null, "code" to code)))
            }
        }

        get("/index") {
            if (!isAuthenticated(call)) return@get goToVerify(call)
            call.respond(FreeMarkerContent(
                "index.ftl",
                mapOf(
                    "motd" to PlainTextComponentSerializer.plainText().serialize(main.server.motd()),
                    "onlinePlayers" to main.server.onlinePlayers.size,
                    "maxPlayers" to main.server.maxPlayers,
                    "version" to Bukkit.getBukkitVersion(),
                    "logs" to getLog()
                ), ""
            ))
        }

        get("/plugins") {
            if (!isAuthenticated(call)) return@get goToVerify(call)
            val list = Bukkit.getPluginsFolder().listFiles()
                ?.filter { it.name.endsWith(".jar") }
                ?.map { it.name } ?: emptyList()
            call.respond(FreeMarkerContent(
                "plugins.ftl",
                mapOf(
                    "count" to list.size,
                    "plugins" to list.joinToString(",")
                ), ""
            ))
        }

        get("/players") {
            if (!isAuthenticated(call)) return@get goToVerify(call)
            try {
                fun banned() = Bukkit.getOfflinePlayers().count { it.isBanned }
                val players = Bukkit.getOnlinePlayers().associate { it.name to it.uniqueId.toString() }
                call.respond(FreeMarkerContent(
                    "players.ftl",
                    mapOf(
                        "online" to Bukkit.getOnlinePlayers().size,
                        "banned" to banned(),
                        "players" to players.keys.joinToString(","),
                        "playerData" to players
                    ), ""
                ))
            } catch (e: Exception) {
                call.respondText(e.toString())
            }
        }

        post("/players-data") {
            val list= Bukkit.getOnlinePlayers().joinToString(",") { it.name }
            val json=JsonObject()
            json.addProperty("players", list)
            call.respondText(json.toString())
        }

        post("plugins-data") {
            val list= Bukkit.getPluginsFolder().listFiles()?.map { it.name } ?: emptyList()
            val json=JsonObject()
            json.addProperty("plugin", list.joinToString(","))

            call.respondText(json.toString())
        }

        get("/player-info") {
            try {
                val uuid = call.parameters["uuid"] ?: return@get
                call.respondText(PlayerDetails.getJson(UUID.fromString(uuid)))
            } catch (e: IllegalArgumentException) {
                call.respondText("Invalid UUID", status = HttpStatusCode.BadRequest)
            } catch (e: Exception) {
                call.respondText("Internal Server Error", status = HttpStatusCode.InternalServerError)
            }
        }

        get("/logs") {
            val logs = getLog()
            call.respondText(logs, ContentType.Text.Plain)
        }
    }
}