plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_hafs")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
