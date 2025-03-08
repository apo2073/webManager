package kr.apo2073

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import kr.apo2073.plugins.module
import org.bukkit.plugin.java.JavaPlugin

class Main: JavaPlugin() {
    companion object {
        lateinit var plugin:Main
    }
    private lateinit var engine: EmbeddedServer<NettyApplicationEngine, NettyApplicationEngine.Configuration>
    override fun onEnable() {
        plugin=this

        saveDefaultConfig()
        saveResource("templates/index.ftl", true)
//        saveResource("templates/index.js", true)

        engine= embeddedServer(
            Netty, port = 8080,
            host = "0.0.0.0",
            module = Application::module
        ).start(wait = false)
    }

    override fun onDisable() {
        try {
            if (::engine.isInitialized) {
                engine.stop( // Main.kt:30
                    1000,
                    5000
                )
            }
        } catch (e: NoClassDefFoundError) { return }
    }
}