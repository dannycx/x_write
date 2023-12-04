package com.dcxing.write.x_write

import android.os.Build
import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    // 通讯名称，回到手机桌面
    private final String chanel = "back/desktop"

    // 返回手机桌面事件
    final String eventBackDesktop = "backDesktop"

    @Override
    fun onCreate(saveInstanceState: Bundle?) {
        super.onCreate(saveInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES_LOLLIPOP) {
            // >21状态栏透明
            window.statusBarColor = 0
        }

        GeneratedPluginRegistrant.registerWith(this)
        initBackTop()
    }

    private fun initBackTop() {
        MethodChannel(flutterView, chanel).setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals(eventBackDesktop)) {
                moveTaskToBack(false);
                result.success(true);
            }
        })
    }
}
