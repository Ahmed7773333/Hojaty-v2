plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_douri")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
