package dev.cwolf.play_services_block_store.play_services_block_store

import android.content.Context
import androidx.annotation.NonNull
import com.google.android.gms.auth.blockstore.Blockstore
import com.google.android.gms.auth.blockstore.BlockstoreClient
import com.google.android.gms.auth.blockstore.DeleteBytesRequest
import com.google.android.gms.auth.blockstore.RetrieveBytesRequest
import com.google.android.gms.auth.blockstore.StoreBytesData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PlayServicesBlockStorePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var client: BlockstoreClient
    val chunkSize =  4000 // max bytes allowed to stored per key via block store so need to split it up if it is larger
    val maxEntries =  16 // max entries allowed to be stored

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
            "retrieveBytes" -> {
                val key = call.argument<String>("key")
                if (key == null) {
                    result.success(null)
                } else {
                    retrieveData(key) { data -> result.success(data) }
                }
            }
            "delete" -> delete(call, result)
            "deleteAll" -> deleteAll(result)
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
            result.success(false)
            return
        }
        saveData(key, value.toByteArray(), result)
    }

    private fun saveBytes(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
        val byteValue =
            call.argument<ByteArray>("value") // Now directly a byte array from Uint8List
        if (key == null || byteValue == null) {
            result.success(null)
            return
        }
        saveData(key, byteValue, result)
    }

    private fun saveData(key: String, data: ByteArray, result: Result) {
        if (data.size <= chunkSize) {
            client.isEndToEndEncryptionAvailable().addOnSuccessListener { isE2E ->
                val builder = StoreBytesData.Builder()
                    .setKey(key)
                    .setBytes(data)

                if (isE2E) {
                    builder.setShouldBackupToCloud(true)
                }

                val request = builder.build()
                client.storeBytes(request)
                    .addOnSuccessListener { result.success(true) }
                    .addOnFailureListener { result.success(false) }
            }
        } else {
            val totalChunks = (data.size + chunkSize - 1) / chunkSize
            if (totalChunks > maxEntries) {
                result.success(false)
                return;
            }
            fun storeNextChunk(index: Int) {
                if (index >= totalChunks) {
                    result.success(true)
                    return
                }
                val start = index * chunkSize
                val end = minOf(start + chunkSize, data.size)
                val chunk = data.copyOfRange(start, end)
                val chunkKey = if (index == 0) key else "${key}_part_$index"
                client.isEndToEndEncryptionAvailable().addOnSuccessListener { isE2E ->
                    val builder = StoreBytesData.Builder()
                        .setKey(chunkKey)
                        .setBytes(chunk)

                    if (isE2E) {
                        builder.setShouldBackupToCloud(true)
                    }

                    val request = builder.build()

                    client.storeBytes(request)
                        .addOnSuccessListener { storeNextChunk(index + 1) }
                        .addOnFailureListener { result.success(false) }
                }
            }
            storeNextChunk(0)
        }
    }

    private fun retrieveData(key: String, onResult: (ByteArray?) -> Unit) {
        val request = RetrieveBytesRequest.Builder().setKeys(listOf(key)).build()
        client.retrieveBytes(request).addOnSuccessListener { response ->
            val firstChunk = response.blockstoreDataMap[key]?.bytes

            if (firstChunk == null) {
                onResult(null)
                return@addOnSuccessListener
            }

            if (firstChunk.size < chunkSize) {
                onResult(firstChunk)
                return@addOnSuccessListener
            }

            val chunks = mutableListOf<ByteArray>()
            chunks.add(firstChunk)
            var partIndex = 1

            fun loadNextChunk() {
                val partKey = "${key}_part_$partIndex"
                val partRequest = RetrieveBytesRequest.Builder().setKeys(listOf(partKey)).build()
                client.retrieveBytes(partRequest).addOnSuccessListener { partResponse ->
                    val partChunk = partResponse.blockstoreDataMap[partKey]?.bytes
                    if (partChunk != null) {
                        chunks.add(partChunk)
                        if (partChunk.size == chunkSize) {
                            partIndex++
                            loadNextChunk()
                        } else {
                            onResult(concatenateChunks(chunks))
                        }
                    } else {
                        onResult(concatenateChunks(chunks))
                    }
                }.addOnFailureListener {
                    onResult(null)
                }
            }
            loadNextChunk()
        }.addOnFailureListener {
            onResult(null)
        }
    }

    private fun concatenateChunks(chunks: List<ByteArray>): ByteArray {
        val totalSize = chunks.sumOf { it.size }
        val result = ByteArray(totalSize)
        var offset = 0
        for (chunk in chunks) {
            chunk.copyInto(result, offset)
            offset += chunk.size
        }
        return result
    }

    private fun retrieveString(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
        if (key == null) {
            result.success(null)
            return
        }
        retrieveData(key) { data ->
            val stringValue = data?.toString(Charsets.UTF_8)
            data?.size
            result.success(stringValue)
        }
    }

    private fun delete(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
        if (key == null) {
            result.success(false)
            return
        }
        val request = DeleteBytesRequest.Builder().setKeys(listOf(key)).build()
        client.deleteBytes(request)
        result.success(true)
    }

    private fun deleteAll(result: Result) {
        val request = DeleteBytesRequest.Builder().setDeleteAll(true).build()
        client.deleteBytes(request)
        result.success(true)
    }
}