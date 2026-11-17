plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_qudsi40")
    dynamicDelivery {
        deliveryType.set("on-demand") 
    }
}
