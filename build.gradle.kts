// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.0.10" apply false
    id("com.google.dagger.hilt.android") version "2.48.1" apply false
}

subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().all {
        kotlinOptions.jvmTarget = JavaVersion.VERSION_1_8.toString()
    }
}

buildscript {
    repositories {
        mavenCentral()
        google()
        gradlePluginPortal()
    }

    dependencies {
        val navVersion = "2.8.0"
        classpath("androidx.navigation:navigation-safe-args-gradle-plugin:$navVersion")
    }
}
