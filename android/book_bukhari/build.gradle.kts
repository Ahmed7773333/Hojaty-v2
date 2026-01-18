plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_bukhari")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
