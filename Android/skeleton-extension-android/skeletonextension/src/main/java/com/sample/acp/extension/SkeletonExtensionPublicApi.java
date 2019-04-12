package com.sample.acp.extension;

import com.adobe.marketing.mobile.MobileCore;

public class SkeletonExtensionPublicApi {
    private static final String LOG_TAG = "Skeleton Extension";

    /**
     * Registers the extension. This method should be called once.
     */
    public static void registerExtension() {
        MobileCore.registerExtension(SkeletonExtension.class, null);
    }
}
