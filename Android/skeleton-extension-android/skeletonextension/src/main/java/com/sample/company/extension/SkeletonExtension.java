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

package com.sample.company.extension;

import com.adobe.marketing.mobile.Event;
import com.adobe.marketing.mobile.Extension;
import com.adobe.marketing.mobile.ExtensionApi;
import com.adobe.marketing.mobile.ExtensionError;
import com.adobe.marketing.mobile.ExtensionErrorCallback;
import com.adobe.marketing.mobile.ExtensionUnexpectedError;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class SkeletonExtension extends Extension {
    private static final String LOG_TAG = "SkeletonExtension";
    private ConcurrentLinkedQueue<Event> eventQueue;
    private ExecutorService executorService;
    private final Object executorMutex = new Object();

    private String stateValue;


    /**
     * Called by the Mobile SDK when registering the extension.
     * Initialize the extension and register event listeners.
     * The example below uses {@link SkeletonExtensionListener} to handle all interesting events,
     * however separate {@link com.adobe.marketing.mobile.ExtensionListener} classes may be used
     * instead.
     * It is recommended to listen for each specific event the extension is interested in.
     * Use of a wildcard listener is discouraged in production environments.
     *
     * @param extensionApi the {@link ExtensionApi} instance for this extension
     */
    protected SkeletonExtension(final ExtensionApi extensionApi) {
        super(extensionApi);

        // register a listener for shared state changes
        extensionApi.registerEventListener(
                SkeletonExtensionConstants.EVENT_TYPE_ADOBE_HUB,
                SkeletonExtensionConstants.EVENT_SOURCE_ADOBE_SHARED_STATE,
                SkeletonExtensionListener.class, new ExtensionErrorCallback<ExtensionError>() {
                    @Override
                    public void error(ExtensionError extensionError) {
                        MobileCore.log(LoggingMode.ERROR, LOG_TAG, "There was an error registering Extension Listener for shared state events: " + extensionError.getErrorName());
                    }
                });

        // register a listener for SkeletonExtension request events
        extensionApi.registerEventListener(
                SkeletonExtensionConstants.EVENT_TYPE_EXTENSION,
                SkeletonExtensionConstants.EVENT_SOURCE_EXTENSION_REQUEST_CONTENT,
                SkeletonExtensionListener.class, new ExtensionErrorCallback<ExtensionError>() {
                    @Override
                    public void error(ExtensionError extensionError) {
                        MobileCore.log(LoggingMode.ERROR, LOG_TAG, "There was an error registering Extension Listener for extension request content events: " + extensionError.getErrorName());
                    }
                });

        this.eventQueue = new ConcurrentLinkedQueue<>();
    }

    /**
     * Required override. Each extension must have a unique name within the application.
     * @return unique name of this extension
     */
    @Override
    protected String getName() {
        return "com.sample.company.SkeletonExtension";
    }

    /**
     * Optional override.
     * @return the version of this extension
     */
    @Override
    protected String getVersion() {
        return "1.0.0";
    }

    /**
     * Optional override. Clean up any open resources before extension is deleted.
     */
    @Override
    protected void onUnregistered() {
        super.onUnregistered();

        // the extension was unregistered
        // if the shared states are not used in the next registration they can be cleared in this method
        getApi().clearSharedEventStates(null);
    }

    /**
     * Optional override but recommended to handle notifications of unexpected errors
     * generated from the Mobile SDK.
     * @param unexpectedError the error instance
     */
    @Override
    protected void onUnexpectedError(final ExtensionUnexpectedError unexpectedError) {
        super.onUnexpectedError(unexpectedError);
    }

    /**
     * Called by {@link SkeletonExtensionListener}.
     * @param event the received event to be queued
     */
    void queueEvent(final Event event) {
        if (event == null) {
            return;
        }

        eventQueue.add(event);
    }

    /**
     * Called by {@link SkeletonExtensionListener}.
     * In this example, the Configuration shared state is required
     * (for example a network URL or a service key may be extracted).
     * If the Configuration shared state is null it means the shared state is pending.
     * The logic below will exit processing the event queue if the Configuration shared state is
     * not available. This extension registers a listener for events of type
     * {@link com.adobe.marketing.mobile.EventType#HUB} and source
     * {@link com.adobe.marketing.mobile.EventSource#SHARED_STATE} to kick processing of
     * queued events when a Configuration shared state is available.
     */
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

            // example of processing different events based on contained EventData
            Map<String, Object> requestData = eventToProcess.getEventData();
            if (requestData != null && requestData.containsKey(SkeletonExtensionConstants.EVENT_SETTER_REQUEST_DATA_KEY)) {
                processSetterRequestEvent(eventToProcess);
            } else {
                processGetterRequestEvent(eventToProcess);
            }

            // event processed, remove it from the queue
            eventQueue.poll();
        }
    }

    /**
     * Process an {@code Event} which expects a response. Builds a response {@link Event} with
     * the requested data (in this case a simple string) then dispatches the response event
     * along with the paired request event.
     * @param requestEvent the requesting {@code Event}
     */
    private void processGetterRequestEvent(final Event requestEvent) {
        Map<String, Object> responseData = new HashMap<>();
        responseData.put(SkeletonExtensionConstants.EVENT_GETTER_RESPONSE_DATA_KEY, this.stateValue);
        Event responseEvent = new Event.Builder("Extension Get Response",
                SkeletonExtensionConstants.EVENT_TYPE_EXTENSION,
                SkeletonExtensionConstants.EVENT_SOURCE_EXTENSION_RESPONSE_CONTENT)
                .setEventData(responseData)
                .build();

        if (responseEvent == null) {
            MobileCore.log(LoggingMode.WARNING, getName(), "An error occurred constructing the response event.");
            /* Even though the response event is nil, continue to call ACPCore::dispatchResponseEvent as a response still needs
            to be dispatched to the waiting paired listener.
            */
        }

        // dispatch the response for the public API
        ExtensionErrorCallback<ExtensionError> errorCallback = new ExtensionErrorCallback<ExtensionError>() {
            @Override
            public void error(final ExtensionError e) {
                MobileCore.log(LoggingMode.WARNING, getName(), String.format("An error occurred dispatching the response event: %s", e.getErrorName()));
            }
        };

        MobileCore.dispatchResponseEvent(responseEvent, requestEvent, errorCallback);
    }

    /**
     * Process an {@code Event} which passes data to the extension. Store received data
     * to this extension's shared state. No response event is required.
     * @param requestEvent the requesting {@code Event}
     */
    private void processSetterRequestEvent(final Event requestEvent) {
        Map<String, Object> requestData = requestEvent.getEventData();
        this.stateValue = (String) requestData.get(SkeletonExtensionConstants.EVENT_SETTER_REQUEST_DATA_KEY);

        // save new data to extension's shared state making it available for other extensions
        // and as a data element for rules processing
        Map<String, Object> extensionState = new HashMap<>();
        extensionState.put(SkeletonExtensionConstants.EVENT_SETTER_REQUEST_DATA_KEY, this.stateValue);
        getApi().setSharedEventState(extensionState, requestEvent, null);
    }

    /**
     * Called by {@link SkeletonExtensionListener} to retrieve an {@code ExecutorService}.
     * The {@code ExecutorService} is used to process events on a separate thread than the
     * {@code EventHub} thread on which they were received. Processing events on a separate
     * thread prevents blocking of the {@code EventHub}.
     *
     * @return this extension's instance of a single thread executor
     */
    ExecutorService getExecutor() {
        synchronized (executorMutex) {
            if (executorService == null) {
                executorService = Executors.newSingleThreadExecutor();
            }

            return executorService;
        }
    }

}


