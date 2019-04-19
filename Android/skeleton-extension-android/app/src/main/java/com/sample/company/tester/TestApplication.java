/*
  ADOBE CONFIDENTIAL
  Copyright 2019 Adobe
  All Rights Reserved.
  NOTICE: Adobe permits you to use, modify, and distribute this file in
  accordance with the terms of the Adobe license agreement accompanying
  it. If you have received this file from a source other than Adobe,
  then your use, modification, or distribution of it requires the prior
  written permission of Adobe.
 */

package com.sample.company.tester;

import android.app.Application;
import android.util.Log;

import com.adobe.marketing.mobile.*;
import com.sample.company.extension.SkeletonExtensionPublicApi;

import java.util.HashMap;
import java.util.Map;


public class TestApplication extends Application {
    private static final String LOG_TAG = "Test Application";

    // TODO: fill in your Launch environment ID here
    private final String LAUNCH_ENVIRONMENT_ID = "";

    @Override
    public void onCreate() {
        super.onCreate();
        MobileCore.setApplication(this);

        MobileCore.setLogLevel(LoggingMode.VERBOSE);

        /* Launch generates a unique environment ID that the SDK uses to retrieve your
        configuration. This ID is generated when an app configuration is created and published to
        a given environment. It is strongly recommended to configure the SDK with the Launch
        environment ID.
        */
        MobileCore.configureWithAppID(LAUNCH_ENVIRONMENT_ID);

        // register Adobe core extensions
        try {
            Identity.registerExtension();
            Signal.registerExtension();
            Lifecycle.registerExtension();
        } catch (InvalidInitException e) {
            e.printStackTrace();
        }

        // register the extension
        SkeletonExtensionPublicApi.registerExtension();

        // once all the extensions are registered, call MobileCore.start(...) to start processing the events
        MobileCore.start(new AdobeCallback() {
            @Override
            public void call(final Object o) {
                Log.d(LOG_TAG, "Mobile SDK was initialized");

                // uncomment updateConfiguration call if LAUNCH_ENVIRONMENT_ID is not set to initialize Configuration extension
                Map<String, Object> config = new HashMap<>();
                config.put("global.privacy", "optedin");
                config.put("com.sample.company.configkey", "example.config.value"); // add a custom configuration value
                MobileCore.updateConfiguration(config);
            }
        });
    }
}
