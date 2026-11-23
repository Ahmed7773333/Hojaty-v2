plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_darimi")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
