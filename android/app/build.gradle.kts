plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
import java.util.Properties
import java.io.FileInputStream

// 1. Load the key.properties file
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.wolfdev.hojaty"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    // 2. Define the signing configuration
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }



    defaultConfig {
        applicationId = "com.wolfdev.hojaty"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        assetPacks += ":quran_hafs"
        assetPacks += ":quran_warsh"
        assetPacks += ":quran_qalon"
        assetPacks += ":quran_douri"
        assetPacks += ":quran_shubah"
        // New Books
        assetPacks += ":book_bukhari"
        assetPacks += ":book_muslim"
        assetPacks += ":book_nasai"
        assetPacks += ":book_abudawud"
        assetPacks += ":book_tirmidhi"
        assetPacks += ":book_ibnmajah"
        assetPacks += ":book_malik"
        assetPacks += ":book_ahmed"
        assetPacks += ":book_darimi"
        assetPacks += ":book_nawawi40"
        assetPacks += ":book_qudsi40"
        assetPacks += ":book_shahwaliullah40"
        assetPacks += ":book_riyad"
        assetPacks += ":book_bulugh"
        assetPacks += ":book_mishkat"
        assetPacks += ":book_adab"
        assetPacks += ":book_shamail"
        assetPacks += ":book_adhkar"
        assetPacks += ":book_duaa"
    }

    buildTypes {
        release {
            // 3. Use the release signing config instead of debug
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

kotlin {
    jvmToolchain(17)
}

flutter {
    source = "../.."
}
