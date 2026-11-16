plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_elbaz_003")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
