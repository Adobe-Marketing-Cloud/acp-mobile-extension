package com.sample.acp.extension;

import com.adobe.marketing.mobile.ExtensionError;
import com.adobe.marketing.mobile.ExtensionErrorCallback;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;

public class SkeletonExtensionPublicApi {
    private static final String LOG_TAG = "Skeleton Extension";

    /**
     * Registers the extension with the Mobile SDK. This method should be called once.
     */
    public static void registerExtension() {
        MobileCore.registerExtension(SkeletonExtension.class, new ExtensionErrorCallback<ExtensionError>() {
            @Override
            public void error(ExtensionError extensionError) {
                MobileCore.log(LoggingMode.ERROR, LOG_TAG, "There was an error registering the SkeletonExtension: " + extensionError.getErrorName());
            }
        });
    }
}
