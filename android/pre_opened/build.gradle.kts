plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("pre_opened")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
