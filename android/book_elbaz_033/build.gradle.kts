plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_elbaz_033")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
