package com.sample.acp.extension;

import com.adobe.marketing.mobile.Event;
import com.adobe.marketing.mobile.Extension;
import com.adobe.marketing.mobile.ExtensionApi;
import com.adobe.marketing.mobile.ExtensionError;
import com.adobe.marketing.mobile.ExtensionErrorCallback;
import com.adobe.marketing.mobile.ExtensionUnexpectedError;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;

import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class SkeletonExtension extends Extension {
    private ConcurrentLinkedQueue<Event> eventQueue;
    private ExecutorService executorService;
    private final Object executorMutex = new Object();


    protected SkeletonExtension(final ExtensionApi extensionApi) {
        super(extensionApi);

        // register a listener for shared state changes
        extensionApi.registerEventListener(
                SkeletonExtensionConstants.EVENT_TYPE_ADOBE_HUB,
                SkeletonExtensionConstants.EVENT_SOURCE_ADOBE_SHARED_STATE,
                SkeletonExtensionListener.class, null);

        // register a listener for SkeletonExtension request events
        extensionApi.registerEventListener(
                SkeletonExtensionConstants.EVENT_TYPE_SKELETON_EXTENSION,
                SkeletonExtensionConstants.EVENT_SOURCE_SKELETON_REQUEST_CONTENT,
                SkeletonExtensionListener.class, null);

        this.eventQueue = new ConcurrentLinkedQueue<>();
    }

    @Override
    protected String getName() {
        return "com.sample.extension";
    }

    @Override
    protected String getVersion() {
        return "1.0.0";
    }

    @Override
    protected void onUnregistered() {
        super.onUnregistered();

        // the extension was unregistered
        // if the shared states are not used in the next registration they can be cleared in this method
        getApi().clearSharedEventStates(null);
    }

    @Override
    protected void onUnexpectedError(final ExtensionUnexpectedError unexpectedError) {
        super.onUnexpectedError(unexpectedError);
    }

    void queueEvent(final Event event) {
        if (event == null) {
            return;
        }

        eventQueue.add(event);
    }

    void processEvents() {
        while (!eventQueue.isEmpty()) {
            Event eventToProcess = eventQueue.peek();

            ExtensionErrorCallback<ExtensionError> extensionErrorCallback = new ExtensionErrorCallback<ExtensionError>() {
                @Override
                public void error(final ExtensionError extensionError) {
                    MobileCore.log(LoggingMode.ERROR, getName(), String.format("Could not process event, an error occurred while retrieving configuration shared state: %s", extensionError.getErrorName()));
                }
            };
            Map<String, Object> configSharedState = getApi().getSharedEventState(SkeletonExtensionConstants.SharedState.CONFIGURATION, eventToProcess, extensionErrorCallback);

            // NOTE: configuration is mandatory processing the event, so if shared state is null (pending) stop processing events
            if (configSharedState == null) {
                MobileCore.log(LoggingMode.DEBUG, getName(), "Could not process event, configuration shared state is pending");
                return;
            }

            // event processed, remove it from the queue
            eventQueue.poll();
        }
    }

    ExecutorService getExecutor() {
        synchronized (executorMutex) {
            if (executorService == null) {
                executorService = Executors.newSingleThreadExecutor();
            }

            return executorService;
        }
    }

}


