package kr.apo2073.utilities

import com.google.gson.JsonObject
import kr.apo2073.Main
import me.clip.placeholderapi.PlaceholderAPI
import org.bukkit.Bukkit
import java.util.UUID

class PlayerDetails {
    private val plugin = Main.plugin
    companion object {
        fun getJson(uuid: UUID): String {
            val list = Main.plugin.config.getStringList("player-info")
            val json=JsonObject()
            for (value in list) {
                val key=value.split(": ")
                json.addProperty(key[0],
                    "<strong>${key[0]}</strong>: ${
                        PlaceholderAPI.setPlaceholders(Bukkit.getPlayer(uuid) ?: return "", key[1])
                    }"
                )
            }
            return json.toString()
        }
    }
}
