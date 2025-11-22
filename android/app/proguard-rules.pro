# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in C:\Users\ariif\AppData\Local\Android\Sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Prevent R8 from stripping common libraries
-keep class com.google.** { *; }
-dontwarn com.google.**
-keep class androidx.** { *; }
-dontwarn androidx.**
-keep class android.support.** { *; }
-dontwarn android.support.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
