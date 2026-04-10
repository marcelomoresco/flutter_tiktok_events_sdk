plugins {
    id("com.android.library")
    id("com.github.ben-manes.versions") version "0.53.0"
}

val agpVersion: String = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION
if (agpVersion.split(".")[0].toInt() < 9) {
    apply(plugin = "kotlin-android")
}

rootProject.allprojects {
    repositories {
        maven { url = uri("https://jitpack.io") }
    }
}

android {
    namespace = "com.example.tiktok_events_sdk"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
        consumerProguardFiles("consumer-rules.pro")
    }

    dependencies {
        implementation("com.github.tiktok:tiktok-business-android-sdk:1.6.0")
        implementation("androidx.lifecycle:lifecycle-process:2.9.4")
        implementation("androidx.lifecycle:lifecycle-common-java8:2.9.4")
        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.mockito:mockito-core:5.20.0")
    }

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()

            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                outputs.upToDateWhen { false }
                showStandardStreams = true
            }
        }
    }
}
