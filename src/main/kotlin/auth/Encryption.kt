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
        private const val a = "WEBMANAGER"
        private const val b = "RandomSaltValue"
        private const val c = "AES/CBC/PKCS5Padding"

        private fun d(): SecretKeySpec {
            val e = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
            val f = PBEKeySpec(a.toCharArray(), b.toByteArray(), 65536, 256)
            val g = e.generateSecret(f)
            return SecretKeySpec(g.encoded, "AES")
        }

        private fun h(): IvParameterSpec {
            val i = ByteArray(16)
            SecureRandom().nextBytes(i)
            return IvParameterSpec(i)
        }

        fun j(k: String): String {
            val l = Cipher.getInstance(c)
            val m = h()
            l.init(Cipher.ENCRYPT_MODE, d(), m)
            val n = l.doFinal(k.toByteArray(Charsets.UTF_8))
            val o = m.iv + n
            return Base64.getEncoder().encodeToString(o)
        }

        fun p(q: String): String {
            val r = Base64.getDecoder().decode(q)
            val s = IvParameterSpec(r.copyOfRange(0, 16))
            val t = r.copyOfRange(16, r.size)
            val u = Cipher.getInstance(c)
            u.init(Cipher.DECRYPT_MODE, d(), s)
            return String(u.doFinal(t), Charsets.UTF_8)
        }
    }
}