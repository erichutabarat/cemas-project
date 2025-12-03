# ----------------------------------------------------------
# FIX FOR BUILD ERRORS (Google Tink / Firebase / Annotations)
# ----------------------------------------------------------

# Ignore missing compile-time annotations (caused your specific error)
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn java.lang.invoke.**

# Ignore warnings from the Google Crypto Tink library
-dontwarn com.google.crypto.tink.**
-keep class com.google.crypto.tink.** { *; }

# ----------------------------------------------------------
# FIX FOR GOOGLE PLAY CORE (Split Install / Deferred Components)
# ----------------------------------------------------------
# Fixes "Missing class com.google.android.play.core.splitcompat..."
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# ----------------------------------------------------------
# STANDARD FLUTTER RULES
# ----------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }