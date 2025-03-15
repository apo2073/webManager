package kr.apo2073.cmds

import kr.apo2073.Main

object TabCompleter {
    private val plugin = Main.plugin

    fun getCompleter(command: String, args: Array<String>): List<String> {
        if (command.isBlank()) {
            plugin.logger.info("Tab completion skipped: empty command")
            return emptyList()
        }

        val pluginCommand = plugin.getCommand(command)
        if (pluginCommand == null) {
            plugin.logger.info("Tab completion: Command '$command' not found")
            return emptyList()
        }

        val tabCompleter = pluginCommand.tabCompleter ?: run {
            plugin.logger.info("Tab completion: No tab completer for '$command'")
            return emptyList()
        }

        return try {
            tabCompleter.onTabComplete(
                plugin.server.consoleSender,
                pluginCommand,
                command,
                args
            )?.filterNotNull() ?: emptyList()
        } catch (e: Exception) {
            plugin.logger.severe("Tab completion failed for '$command': ${e.message}")
            emptyList()
        }
    }
}