plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_adab")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
