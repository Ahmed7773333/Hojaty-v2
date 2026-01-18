plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_adhkar")
    dynamicDelivery {
        deliveryType.set("fast-follow") 
    }
}
