package kr.apo2073.utilities

import java.io.File

fun getLog():String {
    val logFile=File("logs/latest.log")
    if (logFile.exists()) {
        return logFile.readText()
    }
    return "로그 파일을 찾을 수 없습니다."
}