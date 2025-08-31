package com.hafiz.app.hafiz_app

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Opt-in to edge-to-edge in a backwards compatible way
        WindowCompat.setDecorFitsSystemWindows(window, false)
        // Let system pick light/dark nav/status icon color based on content later
        val controller = WindowInsetsControllerCompat(window, window.decorView)
        controller.isAppearanceLightStatusBars = false
        controller.isAppearanceLightNavigationBars = false
    }
}
