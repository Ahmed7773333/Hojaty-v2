plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("book_elbaz_005")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}
