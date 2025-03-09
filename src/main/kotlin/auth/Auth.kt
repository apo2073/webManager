package kr.apo2073.auth

import java.security.SecureRandom

class Auth {
    fun generateAuthCode(): String {
        val chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        val random = SecureRandom()
        return (1..4).map { chars[random.nextInt(chars.length)] }.joinToString("")
    }
}