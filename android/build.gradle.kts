import com.android.build.gradle.LibraryExtension
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

// The Android Gradle Plugin and the Kotlin Gradle Plugin are deliberately not pinned
// here: the consuming app supplies both, so its builds don't also resolve this plugin's
// toolchain. Versions for standalone builds of this repo live in `android/settings.gradle`.

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

apply(plugin = "com.android.library")

// Dependency-report tooling for maintaining this repo. Only applied when the package is
// built standalone, so consuming builds do not resolve a plugin they never use.
if (project == rootProject) {
    apply(plugin = "com.github.ben-manes.versions")
}

// Whether Kotlin is compiled by AGP's built-in support or by the Kotlin Gradle Plugin is
// decided by `android.builtInKotlin`, a property global to the whole build — not by the
// AGP major version. Gating on the major version breaks host apps running AGP 9 with
// built-in Kotlin disabled, which is the only viable setting for an app whose other
// plugins still apply `kotlin-android`: no Kotlin plugin is applied here, this module's
// sources are never compiled, and the build only fails later in GeneratedPluginRegistrant.
val agpMajor: Int = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION.substringBefore(".").toInt()
val builtInKotlin: Boolean =
    (findProperty("android.builtInKotlin") as String?)?.toBoolean() ?: (agpMajor >= 9)

if (!builtInKotlin) {
    apply(plugin = "org.jetbrains.kotlin.android")
}

configure<LibraryExtension> {
    namespace = "com.example.tiktok_events_sdk"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
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

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()

            it.outputs.upToDateWhen { false }
            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
        }
    }
}

tasks.withType<KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

dependencies {
    "implementation"("com.github.tiktok:tiktok-business-android-sdk:1.7.1")
    "implementation"("androidx.lifecycle:lifecycle-process:2.10.0")
    // The TikTok SDK declares Install Referrer as compileOnly but calls it for install
    // attribution. Shipping it keeps R8 release builds of apps without it from failing.
    "implementation"("com.android.installreferrer:installreferrer:2.2")
    "testImplementation"("org.jetbrains.kotlin:kotlin-test")
    "testImplementation"("org.mockito:mockito-core:5.23.0")
}
