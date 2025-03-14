package kr.apo2073.cmds

import kr.apo2073.Main

class TabCompleter {
    companion object {
        private val plugin= Main.plugin
        fun getCompleter(command:String, array: Array<String>): MutableList<String>? {
            val pluginCommand=plugin.getCommand(command) ?: return null
            val tabComplete=pluginCommand.tabCompleter ?: return null
            return tabComplete.onTabComplete(
                plugin.server.consoleSender,
                pluginCommand,
                command,
                array
            )
        }
    }
}