import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.wolfdev.hojaty"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wolfdev.hojaty"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 37
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    androidResources {
        // Note: androidResources.noCompress populates BundleConfig.pb (uncompressedGlob) across ALL
        // modules in the AAB, including every legacy on-demand asset pack.
        // Keep legacy media extensions aligned with the live Closed Testing release to preserve
        // Play Store binary delta patching (commit 3c73c34e added png/json/jpg/jpeg/webp; if your
        // live Closed Testing baseline predates 1.1.31+51, remove this block altogether).
        // Do NOT include "db" or "sqlite" here: hojaty_rag.db is extracted to disk by Play Asset
        // Delivery and opened via filesystem path in sqflite, not via AssetManager.openFd().
        noCompress += listOf("png", "json", "jpg", "jpeg", "webp", "pdf")
    }

    assetPacks += listOf(
        ":quran_hafs",
        ":quran_warsh",
        ":quran_qalon",
        ":quran_douri",
        ":quran_shubah",
        ":book_bukhari",
        ":book_muslim",
        ":book_nasai",
        ":book_abudawud",
        ":book_tirmidhi",
        ":book_ibnmajah",
        ":book_malik",
        ":book_ahmed",
        ":book_darimi",
        ":book_nawawi40",
        ":book_qudsi40",
        ":book_shahwaliullah40",
        ":book_riyad",
        ":book_bulugh",
        ":book_mishkat",
        ":book_adab",
        ":book_shamail",
        ":book_duaa",
        ":hojaty_rag",
        ":book_elbaz_001",
        ":book_elbaz_002",
        ":book_elbaz_003",
        ":book_elbaz_004",
        ":book_elbaz_005",
        ":book_elbaz_006",
        ":book_elbaz_007",
        ":book_elbaz_009",
        ":book_elbaz_013",
        ":book_elbaz_014",
        ":book_elbaz_017",
        ":book_elbaz_023",
        ":book_elbaz_026",
        ":book_elbaz_033",
        ":book_elbaz_036",
        ":book_elbaz_037",
        ":book_elbaz_039",
        ":book_elbaz_040",
        ":book_elbaz_041",
        ":book_elbaz_043",
        ":book_elbaz_044",
        ":book_elbaz_046",
        ":book_elbaz_048"
    )
}

dependencies {
    implementation("com.google.android.play:asset-delivery:2.2.2")
    implementation("com.google.android.play:asset-delivery-ktx:2.2.2")
    implementation("me.carda:AndroidAwnCore:0.12.1")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
