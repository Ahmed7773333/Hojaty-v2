plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_mishkat")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
