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

#ifndef SkeletonExtensionListener_h
#define SkeletonExtensionListener_h

#import "ACPExtensionEvent.h"
#import "ACPExtensionListener.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An instance of `ACPExtensionListener, the `SkeletonExtensionListener` is registered
 * by its "parent" `SkeletonExtension` to hear specific events which are dispatched by
 * the Mobile SDK Event Hub. Multiple `ExtensionListener` classes may be used to organize
 * the handling of different events, or, as shown in this example, a single class may be used
 * by checking the `EventType` and `EventSource`
 * of the heard event.
 *
 * When handling `Event`s received by the Mobile SDK Event Hub, it is important to process
 * them as quickly as possible. In this example, a background thread is used to process
 * the events on a separate thread, making the execution time of the `hear` method
 * relatively quick.
 */
@interface SkeletonExtensionListener : ACPExtensionListener

/**
 * Override from `ACPExtensionListener`. Called by SDK EventHub when an event is received of the same type and source
 * as this listener is registered.
 */
- (void) hear:(ACPExtensionEvent *)event;

@end

NS_ASSUME_NONNULL_END

#endif /* SkeletonExtensionListener_h */
