package dev.dhina17.template.ui

import android.app.AppOpsManager
import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.os.Bundle
import android.os.Process
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import dev.dhina17.template.databinding.FragmentEmptyBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


@AndroidEntryPoint
class EmptyFragment : Fragment() {

    private lateinit var binding: FragmentEmptyBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentEmptyBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        if (haveUsageStatsPermission()) {
            Log.i("dhina17test", "Have permission")
            binding.permission.text ="Have permission"
            lifecycleScope.launch {
                val wifiBucket = getWifiUsageSummary()
                val mobileBucket = getMobileUsageSummary()
                binding.wifiReceived.text = "Down => ${wifiBucket.rxBytes.mB} MB"
                binding.wifiSent.text = "Up => ${wifiBucket.txBytes.mB} MB"
                binding.mobileReceived.text = "Down => ${mobileBucket.rxBytes.mB} MB"
                binding.mobileSent.text = "Up => ${mobileBucket.txBytes.mB} MB"
            }
        } else {
            Log.i("dhina17test", "Have no permission")
            binding.permission.text ="No permission. Restart after granting..."
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            startActivity(intent)
        }
    }

    private suspend fun getDataUsageSummary(networkType: Int): NetworkStats.Bucket {
        return withContext(Dispatchers.IO) {
            val service = requireContext().getSystemService(NetworkStatsManager::class.java)
            service.querySummaryForDevice(networkType, null,  System.currentTimeMillis() - 86400000, System.currentTimeMillis())
        }
    }

    private suspend fun getWifiUsageSummary(): NetworkStats.Bucket {
        return getDataUsageSummary(ConnectivityManager.TYPE_WIFI)
    }

    private suspend fun getMobileUsageSummary(): NetworkStats.Bucket {
        return getDataUsageSummary(ConnectivityManager.TYPE_MOBILE)
    }

    private fun haveUsageStatsPermission(): Boolean {
        val appOps = requireContext().getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager?
        val mode = appOps?.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(), requireContext().packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private val Long.mB
        get() = this / 1000000

}
