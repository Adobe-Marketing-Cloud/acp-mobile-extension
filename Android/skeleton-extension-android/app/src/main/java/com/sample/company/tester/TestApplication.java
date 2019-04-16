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

        // set the environment id associated with your Launch mobile property
        MobileCore.configureWithAppID(LAUNCH_ENVIRONMENT_ID);
        MobileCore.setLogLevel(LoggingMode.VERBOSE);

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
                Map<String, Object> config = new HashMap<>();
                config.put("global.privacy", "optedin");
                MobileCore.updateConfiguration(config);
            }
        });
    }
}
