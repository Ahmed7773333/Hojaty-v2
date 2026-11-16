plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_elbaz_048")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
