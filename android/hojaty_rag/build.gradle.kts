plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("hojaty_rag")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
