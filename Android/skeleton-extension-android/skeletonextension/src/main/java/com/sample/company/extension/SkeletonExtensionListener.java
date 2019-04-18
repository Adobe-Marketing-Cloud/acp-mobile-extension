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
import com.adobe.marketing.mobile.ExtensionApi;
import com.adobe.marketing.mobile.ExtensionListener;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;

class SkeletonExtensionListener extends ExtensionListener {

    protected SkeletonExtensionListener(final ExtensionApi extension, final String type, final String source) {
        super(extension, type, source);
    }

    /**
     * Called by SDK {@code EventHub} when an event is received of the same type and source
     * as this listener is registered.
     *
     * @param event the {@link Event} received by the {@code EventHub}
     */
    @Override
    public void hear(final Event event) {
        if (event.getEventData() == null) {
            return;
        }

        final SkeletonExtension parentExtension = getParentExtension();
        if (parentExtension == null) {
            MobileCore.log(LoggingMode.WARNING, "SkeletonExtensionListener", "Unable to process event, parent extension instance is null.");
            return;
        }

        // handle SharedState events
        if (SkeletonExtensionConstants.EVENT_TYPE_ADOBE_HUB.equalsIgnoreCase(event.getType())) {
            if (SkeletonExtensionConstants.SharedState.CONFIGURATION.
                    equalsIgnoreCase((String)event.getEventData().get(SkeletonExtensionConstants.SharedState.STATE_OWNER))) {
                getParentExtension().getExecutor().execute(new Runnable() {
                    @Override
                    public void run() {
                        parentExtension.processEvents();
                    }
                });
            }
        } else if (SkeletonExtensionConstants.EVENT_TYPE_EXTENSION.equalsIgnoreCase(event.getType())) {
            // handle WeatherExtension events
            getParentExtension().getExecutor().execute(new Runnable() {
                @Override
                public void run() {
                    parentExtension.queueEvent(event);
                    parentExtension.processEvents();
                }
            });
        }
    }

    /**
     * Returns the parent extension that owns this listener.
     * @return the extension which registered this listener
     */
    @Override
    protected SkeletonExtension getParentExtension() {
        return (SkeletonExtension) super.getParentExtension();
    }
}
