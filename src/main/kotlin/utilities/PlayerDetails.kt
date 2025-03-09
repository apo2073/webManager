package kr.apo2073.utilities

import com.google.gson.JsonObject
import kr.apo2073.Main
import me.clip.placeholderapi.PlaceholderAPI
import org.bukkit.Bukkit
import java.util.UUID

class PlayerDetails {
    companion object {
        fun getJson(uuid: UUID): String {
            val plugin = Main.plugin
            plugin.reloadConfig()
            val list = plugin.config.getStringList("player-info")
            if (list.isEmpty()) return "{}"
            val player = Bukkit.getPlayer(uuid) ?: return "{}"

            val json = JsonObject()

            for (value in list) {
                val key = value.split(":").map { it.trim() }
                if (key.size < 2) continue

                val placeholderValue = PlaceholderAPI.setPlaceholders(player, key[1])
                json.addProperty(
                    key[0],
                    "<strong>${key[0]}</strong>: $placeholderValue"
                )
            }

            return json.toString()
        }
    }
}