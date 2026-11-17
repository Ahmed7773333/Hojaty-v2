plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_warsh")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
