package kr.apo2073.plugins

import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kr.apo2073.Main

fun Application.configureRouting() {
    val main= Main.plugin
    routing {
        get("/") {
            call.respondRedirect("/index")
        }
        get("/info") {
            call.respondText(
                """
                    name: ${main.pluginMeta.name}
                    version: ${main.pluginMeta.version}
                    bukkit-version: ${main.server.version}
                """.trimIndent()
            )
        }
    }
}
