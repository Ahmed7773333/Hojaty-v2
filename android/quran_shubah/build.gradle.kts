plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_shubah")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
