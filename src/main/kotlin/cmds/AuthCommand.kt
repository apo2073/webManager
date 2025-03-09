package kr.apo2073.cmds

import kr.apo2073.Main
import net.kyori.adventure.text.Component
import net.kyori.adventure.text.minimessage.MiniMessage
import org.bukkit.Bukkit.getServer
import org.bukkit.command.Command
import org.bukkit.command.CommandExecutor
import org.bukkit.command.CommandSender
import org.bukkit.entity.Player
import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse

class AuthCommand:CommandExecutor {
    private val plugin= Main.plugin
    private fun verifyCode(playerName: String, code: String) {
        val client = HttpClient.newHttpClient()
        val request = HttpRequest.newBuilder()
            .uri(URI.create("http://${plugin.config.getString("uri")}:8080/verify-code"))
            .POST(HttpRequest.BodyPublishers.ofString("code=$code"))
            .header("Content-Type", "application/x-www-form-urlencoded")
            .build()

        try {
            val response = client.send(request, HttpResponse.BodyHandlers.ofString())
            if (response.statusCode() == 200) {
                getServer().getPlayer(playerName)!!.sendMessage(prefix.append(Component.text("인증 성공! 웹 페이지를 새로고침 해주세요.")))
            } else {
                getServer().getPlayer(playerName)!!.sendMessage(prefix.append(Component.text("인증 실패: 잘못된 코드")))
            }
        } catch (e: Exception) {
            e.printStackTrace()
            getServer().getPlayer(playerName)!!.sendMessage(prefix.append(Component.text("인증 오류: 서버 연결 실패")))
        }
    }
    private val prefix=MiniMessage.miniMessage().deserialize("<b><gradient:#DBCDF0:#8962C3>[ WebManager]</gradient></b> ")

    override fun onCommand(sender: CommandSender, command: Command, label: String, args: Array<out String>): Boolean {
        if (sender is Player && args.size == 1) {
            val code = args[0]
            verifyCode(sender.getName(), code)
            return true
        }
        return false
    }
}