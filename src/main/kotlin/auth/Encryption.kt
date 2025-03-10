package kr.apo2073.auth

import java.security.SecureRandom
import java.util.*
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

class Encryption {
    companion object {
        private const val SECRET_KEY = "WEBMANAGER"
        private const val SALT = "RandomSaltValue"
        private const val ALGORITHM = "AES/CBC/PKCS5Padding"

        private fun generateKey(): SecretKeySpec {
            val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
            val spec = PBEKeySpec(SECRET_KEY.toCharArray(), SALT.toByteArray(), 65536, 256)
            val secretKey = factory.generateSecret(spec)
            return SecretKeySpec(secretKey.encoded, "AES")
        }

        private fun generateRandomIV(): IvParameterSpec {
            val ivBytes = ByteArray(16)
            SecureRandom().nextBytes(ivBytes)
            return IvParameterSpec(ivBytes)
        }

        fun encrypt(data: String): String {
            val cipher = Cipher.getInstance(ALGORITHM)
            val iv = generateRandomIV()
            cipher.init(Cipher.ENCRYPT_MODE, generateKey(), iv)
            val encrypted = cipher.doFinal(data.toByteArray(Charsets.UTF_8))
            val combined = iv.iv + encrypted
            return Base64.getEncoder().encodeToString(combined)
        }

        fun decrypt(encryptedData: String): String {
            val decoded = Base64.getDecoder().decode(encryptedData)
            val iv = IvParameterSpec(decoded.copyOfRange(0, 16))
            val cipherText = decoded.copyOfRange(16, decoded.size)
            val cipher = Cipher.getInstance(ALGORITHM)
            cipher.init(Cipher.DECRYPT_MODE, generateKey(), iv)
            return String(cipher.doFinal(cipherText), Charsets.UTF_8)
        }
    }
}