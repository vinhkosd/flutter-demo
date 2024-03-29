package com.example.a

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.getPlugins().add(SharedPreferencesPlugin())
    }
}
