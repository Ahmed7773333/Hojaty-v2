plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_assets")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
