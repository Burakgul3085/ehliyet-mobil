import org.gradle.api.file.Directory

plugins {
    // Firebase Google Services plugin (Android tarafında google-services.json'u okuyacak)
    id("com.google.gms.google-services") version "4.4.3" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Flutter'ın build çıktıları için ortak build klasörü ayarı
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // app modülüne bağımlılık (Mustafa'nın projede var olan ayar, aynen bırakıyoruz)
    project.evaluationDependsOn(":app")
}

// Temizlik task'i
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
