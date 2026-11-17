plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_tirmidhi")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
