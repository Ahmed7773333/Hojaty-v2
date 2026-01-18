plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_nasai")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
