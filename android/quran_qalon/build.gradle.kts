plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("quran_qalon")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
