plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_duaa")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
