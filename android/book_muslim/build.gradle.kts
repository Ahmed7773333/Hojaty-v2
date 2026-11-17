plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_muslim")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
