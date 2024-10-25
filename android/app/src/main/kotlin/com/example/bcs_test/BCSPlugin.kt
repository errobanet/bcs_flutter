package com.example.bcs_test
import android.content.Context
import com.erroba.bcssdk.VerifyCallback
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class BCSPlugin : FlutterPlugin{

    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private val CHANNEL = "net.erroba.bcs"

    fun register(flutterEngine: FlutterEngine) {
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        channel = MethodChannel(binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this::onMethodCall)
    }

    fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "faceVerify") {
            val code = call.argument<String>("code")
            faceVerify(code!!, result)
        }
        else if (call.method == "setUrlService") {
            val url = call.argument<String>("url")
            setUrlService(url!!, result)
        }
        else if (call.method == "setColors") {
            val primary = call.argument<String>("primary")
            val onPrimary = call.argument<String>("onPrimary")
            setColors(primary!!,onPrimary!!, result)
        }
        else {
            result.notImplemented()
        }
    }

    private fun setColors(primary: String, onPrimary: String, result: MethodChannel.Result) {
        if (com.erroba.bcssdk.BCSClient.setColors(primary, onPrimary)) {
            result.success("OK")
        }
        else {
            result.error("VALIDATION", "Invalid color. Format: #001122", null);
        }
    }

    private fun faceVerify(code: String, result: MethodChannel.Result) {
        com.erroba.bcssdk.BCSClient.startVerify(context, code, VerifyCallback { response ->
            result.success(response.name)
        })
    }

    private fun setUrlService(url: String, result: MethodChannel.Result) {
        if (com.erroba.bcssdk.BCSClient.setUrlService(url)) {
            result.success("OK")
        }
        else {
            result.error("VALIDATION", "Invalid url", null);
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        context = binding.applicationContext;
        channel.setMethodCallHandler(this::onMethodCall)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }
}