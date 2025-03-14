val kotlin_version: String by project
val logback_version: String by project

plugins {
    kotlin("jvm") version "2.1.0"
    id("io.ktor.plugin") version "3.0.3"
}

group = "kr.apo2073"
version = "0.0.1"

application {
    mainClass.set("kr.apo2073.MainKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()

    maven("https://repo.papermc.io/repository/maven-public/") {
        name = "papermc-repo"
    }
    maven("https://oss.sonatype.org/content/groups/public/") {
        name = "sonatype"
    }
    maven("https://jitpack.io") {
        name= "jitpack"
    }
    maven("https://repo.extendedclip.com/content/repositories/placeholderapi/")
}

dependencies {
    testImplementation("io.ktor:ktor-server-test-host-jvm:3.0.3")
    compileOnly("io.papermc.paper:paper-api:1.21.1-R0.1-SNAPSHOT")
    compileOnly("me.clip:placeholderapi:2.11.6")
    implementation("io.ktor:ktor-server-core")
    implementation("io.ktor:ktor-server-freemarker")
    implementation("io.ktor:ktor-server-netty")
    implementation("ch.qos.logback:logback-classic:$logback_version")
//    testImplementation("io.ktor:ktor-server-test-host")
//    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
}

val targetJavaVersion = 21
kotlin {
    jvmToolchain(targetJavaVersion)
}

tasks.withType<JavaCompile> {
    options.encoding = "UTF-8"
}

tasks.processResources {
    val props = mapOf("version" to version)
    inputs.properties(props)
    filteringCharset = "UTF-8"
    filesMatching("plugin.yml") {
        expand(props)
    }
}

tasks.shadowJar {
    archiveFileName.set("WebManager-Test.jar")
    archiveClassifier.set("")
//    configurations = listOf(project.configurations.runtimeClasspath.get())
//    destinationDirectory=file("C:\\Users\\PC\\Desktop\\Test_Server\\21.1\\plugins")
    destinationDirectory=file("C:\\Users\\이태수\\Desktop\\server\\21.1\\plugins")
    minimize {
        exclude(dependency("io.ktor:.*:.*"))
        exclude(dependency("org.jetbrains.kotlin:.*"))
    }
    manifest {
        attributes["Main-Class"] = "kr.apo2073.MainKt"
    }

    mergeServiceFiles()
}
