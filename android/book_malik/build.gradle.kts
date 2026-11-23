plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_malik")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
