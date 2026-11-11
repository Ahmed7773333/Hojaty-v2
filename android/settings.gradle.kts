pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.1" apply false
    id("com.android.asset-pack") version "9.1.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")
include(":quran_hafs")
include(":quran_warsh")
include(":quran_qalon")
include(":quran_douri")
include(":quran_shubah")

include(":book_bukhari")
include(":book_muslim")
include(":book_nasai")
include(":book_abudawud")
include(":book_tirmidhi")
include(":book_ibnmajah")
include(":book_malik")
include(":book_ahmed")
include(":book_darimi")
include(":book_nawawi40")
include(":book_qudsi40")
include(":book_shahwaliullah40")
include(":book_riyad")
include(":book_bulugh")
include(":book_mishkat")
include(":book_adab")
include(":book_shamail")
include(":book_duaa")
include(":hojaty_rag")

