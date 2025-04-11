// Define buildscript block for classpath dependencies
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.0.2") // Use appropriate AGP version
        classpath("com.google.gms:google-services:4.3.15") // Latest Google Services plugin
    }
}

// Configure project-wide repositories
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)// Define buildscript block for classpath dependencies
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.0.2") // Use appropriate AGP version
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20") // Kotlin Gradle Plugin
        classpath("com.google.gms:google-services:4.3.15") // Latest Google Services plugin
    }
}

// Configure project-wide repositories
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}


}

subprojects {
    project.evaluationDependsOn(":app")
}

// Define clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
