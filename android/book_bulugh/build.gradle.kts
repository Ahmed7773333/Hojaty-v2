plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_bulugh")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
