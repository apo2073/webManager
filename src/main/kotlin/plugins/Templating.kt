package kr.apo2073.plugins

import com.google.gson.JsonObject
import freemarker.cache.ClassTemplateLoader
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.freemarker.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kr.apo2073.Main
import kr.apo2073.utilities.getLog
import net.kyori.adventure.text.serializer.plain.PlainTextComponentSerializer
import org.bukkit.Bukkit

private val main= Main.plugin
fun Application.configureTemplating() {
    install(FreeMarker) {
        templateLoader = ClassTemplateLoader(this::class.java.classLoader, "templates")
    }
    routing {
        get("/index") {
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
        post("/button-test") {
            call.respondText(main.pluginMeta.name)
        }

        get("/players") {
            fun banned(): Int {
                return Bukkit.getOfflinePlayers().count { it.isBanned }
            }
            val players = Bukkit.getOnlinePlayers().associate {
                it.name to it.uniqueId.toString()
            }
            val playerNames = players.keys.joinToString(",")
            call.respond(FreeMarkerContent(
                "players.ftl",
                    mapOf(
                        "online" to Bukkit.getOnlinePlayers().size,
                        "banned" to banned(),
                        "players" to playerNames,
                        "playerData" to players
                    ), "")
            )
        }

        post("/players-data") {
            val list= Bukkit.getOnlinePlayers().joinToString(",") { it.name }
            val json=JsonObject()
            json.addProperty("players", list)
            list.split(",").forEach {
//                json.addProperty(it, Bukkit.getPlayer(it)?.uniqueId.toString() ?: return@forEach)
            }
            call.respondText(json.toString())
        }

        get("/player-info") {
            val uuid=call.queryParameters["uuid"] ?: return@get

        }

        get("/plugins") {
            call.respond(FreeMarkerContent(
                "plugins.ftl",
                mapOf("" to ""), ""
            ))
        }

        get("/logs") {
            val logs = getLog()
            call.respondText(logs, ContentType.Text.Plain)
        }
    }
}