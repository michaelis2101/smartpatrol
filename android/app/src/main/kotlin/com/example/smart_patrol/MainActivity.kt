package com.example.smart_patrol


import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize NFC adapter safely
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        if (nfcAdapter == null) {
            // Handle the case where the device does not support NFC
            println("NFC is not supported on this device")
        } else {
            // Initialize PendingIntent for NFC foreground dispatch
            pendingIntent = PendingIntent.getActivity(
                this,
                0,
                Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
        }
    }

    override fun onResume() {
        super.onResume()

        try {
            // Enable NFC foreground dispatch if NFC is available
            nfcAdapter?.enableForegroundDispatch(this, pendingIntent, null, null)
        } catch (e: Exception) {
            println("Failed to enable NFC foreground dispatch: ${e.message}")
        }
    }

    override fun onPause() {
        super.onPause()

        try {
            // Disable NFC foreground dispatch to release resources
            nfcAdapter?.disableForegroundDispatch(this)
        } catch (e: Exception) {
            println("Failed to disable NFC foreground dispatch: ${e.message}")
        }
    }
}


