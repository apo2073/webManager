package kr.apo2073.plugins

import com.google.gson.Gson
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
import org.bukkit.entity.memory.MemoryKey

private val main= Main.instance
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
            fun banned():Int {
                var count=0
                Bukkit.getOfflinePlayers().forEach {
                    if (it.isBanned) count+=1
                }
                return count
            }
            call.respond(FreeMarkerContent(
                    "players.ftl",
                    mapOf(
                        "online" to main.server.onlinePlayers.size,
                        "banned" to banned()
                    ), ""
            ))
        }

        post("/players-data") {
            val list= Bukkit.getOnlinePlayers().joinToString(",") { it.name }
            val json=JsonObject()
            json.addProperty("players", list)
            list.split(",").forEach {
                json.addProperty(it, Bukkit.getPlayer(it)?.uniqueId.toString())
            }
            call.respondText(json.toString())
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