plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Apply Firebase Gradle plugin
    id("dev.flutter.flutter-gradle-plugin") // The Flutter Gradle Plugin must be applied after Android and Kotlin plugins
}

android {
    namespace = "com.blinqpay.blinqpost"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.blinqpay.blinqpost" // Unique Application ID
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false // Disable code shrinking for now
             isShrinkResources = false  //Disable resource shrinking
            signingConfig = signingConfigs.getByName("debug") // Use debug signing for release build temporarily
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:28.0.0")) // Firebase BoM for managing versions
    implementation("com.google.firebase:firebase-auth") // Firebase Authentication
    implementation("com.google.firebase:firebase-firestore") // Firebase Firestore
}

flutter {
    source = "../.." // Path to Flutter module source code
}
