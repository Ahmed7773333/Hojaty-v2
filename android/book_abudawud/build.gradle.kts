plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_abudawud")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
