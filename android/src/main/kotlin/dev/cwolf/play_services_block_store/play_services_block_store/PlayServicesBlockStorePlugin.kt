package dev.cwolf.play_services_block_store.play_services_block_store

import android.content.Context
import androidx.annotation.NonNull
import com.google.android.gms.auth.blockstore.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** PlayServicesBlockStorePlugin */

class PlayServicesBlockStorePlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var client: BlockstoreClient

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "play_services_block_store")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    client = Blockstore.getClient(context)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "saveString" -> saveString(call, result)
      "saveBytes" -> saveBytes(call, result)
      "retrieveString" -> retrieveString(call, result)
      "retrieveBytes" -> retrieveBytes(call, result)
      "delete" -> delete(call, result)
      "deleteAll" -> deleteAll(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun saveString(call: MethodCall, result: Result) {
    val key = call.argument<String>("key")
    val value = call.argument<String>("value")
    if (key == null || value == null) {
      result.error("INVALID_ARGS", "Missing key or value", null)
      return
    }
    saveData(key, value.toByteArray(), result)
  }

    private fun saveBytes(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
        val byteValue = call.argument<ByteArray>("value") // Now directly a byte array from Uint8List
        if (key == null || byteValue == null) {
            result.error("INVALID_ARGS", "Missing key or byte value", null)
            return
        }
        saveData(key, byteValue, result)
    }

  private fun saveData(key: String, data: ByteArray, result: Result) {
    val request = StoreBytesData.Builder()
      .setKey(key)
      .setBytes(data)
      .build()

    client.storeBytes(request)
      .addOnSuccessListener {
        result.success("Stored ${data.size} bytes for key: $key")
      }
      .addOnFailureListener { e ->
        result.error("STORE_ERROR", e.message, e)
      }
  }


  private fun retrieveString(call: MethodCall, result: Result) {
    val key = call.argument<String>("key")
    if (key == null) {
      result.error("INVALID_ARGS", "Missing key", null)
      return
    }
    val request = RetrieveBytesRequest.Builder().setKeys(listOf(key)).build()

    client.retrieveBytes(request)
      .addOnSuccessListener { response ->
        val data = response.blockstoreDataMap[key]?.bytes
        val stringValue = data?.toString(Charsets.UTF_8)
        result.success(stringValue)
      }
      .addOnFailureListener { e ->
        result.error("RETRIEVE_STRING_ERROR", e.message, e)
      }
  }

  private fun retrieveBytes(call: MethodCall, result: Result) {
    val key = call.argument<String>("key")
    if (key == null) {
      result.error("INVALID_ARGS", "Missing key", null)
      return
    }
    val request = RetrieveBytesRequest.Builder().setKeys(listOf(key)).build()

    client.retrieveBytes(request)
      .addOnSuccessListener { response ->
        val data = response.blockstoreDataMap[key]?.bytes
        result.success(data)
      }
      .addOnFailureListener { e ->
        result.error("RETRIEVE_BYTES_ERROR", e.message, e)
      }
  }

  private fun delete(call: MethodCall, result: Result) {
    val key = call.argument<String>("key")
    if (key == null) {
      result.error("INVALID_ARGS", "Missing key", null)
      return
    }
    val request = DeleteBytesRequest.Builder().setKeys(listOf(key)).build()
    client.deleteBytes(request)
    result.success(true)
  }

  private fun deleteAll(call: MethodCall, result: Result) {
    val request = DeleteBytesRequest.Builder().setDeleteAll(true).build()
    client.deleteBytes(request)
    result.success(true)
  }
}