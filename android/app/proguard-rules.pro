# Keep Picovoice classes and interfaces strictly
-keep class ai.picovoice.** { *; }
-keep interface ai.picovoice.** { *; }
-dontwarn ai.picovoice.**

# Keep JNI interfaces (very important for Porcupine native code)
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve line numbers and attributes for better error messages
-keepattributes SourceFile,LineNumberTable
