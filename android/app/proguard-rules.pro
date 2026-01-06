# Generic Proguard rules for Flutter

# Keep JNI interfaces
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve line numbers and attributes for better error messages
-keepattributes SourceFile,LineNumberTable
