package com.hafiz.app.hafiz_app

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Opt-in to edge-to-edge; icon appearance is managed by Flutter/Dart
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
