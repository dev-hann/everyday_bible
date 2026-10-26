package com.example.everyday_bible

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val channel = "apk_installer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "launchInstaller" -> {
                    val path = call.argument<String>("path")
                    if (path == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    result.success(launchInstaller(path))
                }
                "canRequestPackageInstalls" ->
                    result.success(canRequestPackageInstalls())
                "openInstallPermissionSettings" ->
                    result.success(openInstallPermissionSettings())
                else -> result.notImplemented()
            }
        }
    }

    private fun launchInstaller(path: String): Boolean {
        return try {
            val file = File(path)
            if (!file.exists()) return false
            val authority = "$packageName.fileprovider"
            val uri: Uri = FileProvider.getUriForFile(this, authority, file)
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, "application/vnd.android.package-archive")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun canRequestPackageInstalls(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            true
        }
    }

    private fun openInstallPermissionSettings(): Boolean {
        return try {
            val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                    data = Uri.parse("package:$packageName")
                }
            } else {
                Intent(Settings.ACTION_SECURITY_SETTINGS)
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }
}
