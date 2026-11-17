plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_ibnmajah")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
