plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_ahmed")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
