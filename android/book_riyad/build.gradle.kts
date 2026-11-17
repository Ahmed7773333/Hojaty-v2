plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_riyad")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
