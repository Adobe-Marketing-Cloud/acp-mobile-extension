package com.sample.acp.extension;

class SkeletonExtensionConstants {
    static final String EVENT_TYPE_EXTENSION = "com.sample.acp.eventType.skeletonExtension";
    static final String EVENT_SOURCE_EXTENSION_REQUEST_CONTENT = "com.sample.acp.eventSource.requestContent";
    static final String EVENT_SOURCE_EXTENSION_RESPONSE_CONTENT = "com.sample.acp.eventSource.responseContent";
    static final String EVENT_TYPE_ADOBE_HUB = "com.adobe.eventType.hub";
    static final String EVENT_SOURCE_ADOBE_SHARED_STATE = "com.adobe.eventSource.sharedState";


    class SharedState {
        static final String STATE_OWNER = "stateowner";
        static final String CONFIGURATION = "com.adobe.module.configuration";

        private SharedState(){}
    }


    private SkeletonExtensionConstants() {}
}
