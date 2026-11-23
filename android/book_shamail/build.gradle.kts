plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_shamail")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
