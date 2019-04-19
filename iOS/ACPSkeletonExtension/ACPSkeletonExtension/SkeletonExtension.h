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

#ifndef SkeletonExtension_h
#define SkeletonExtension_h

#import "ACPExtension.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Class {@code SkeletonExtension} is an implementation of {@link Extension} and is responsible
 * for registering {@link com.adobe.marketing.mobile.ExtensionListener}s and processing events
 * heard by those listeners. The extension is registered to the Mobile SDK by calling
 * {@link MobileCore#registerExtension(Class, ExtensionErrorCallback)} which for this example
 * is done in {@link SkeletonExtensionPublicApi}. The {@code SkeletonExtension} provides a basic
 * implementation and example usage for creating a third-party Mobile SDK Extension.
 */
@interface SkeletonExtension : ACPExtension

/* this extension's dispatch queue for processing heard events */
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

/**
 * @brief Queue an event for later processing.
 * Queue events received by extension event listeners.
 */
- (void) queueEvent: (ACPExtensionEvent*) event;

/**
 * @brief Process each event in the event queue.
 * Processes each event in the event queue in the order they were received.
 */
- (void) processEvents;

@end

NS_ASSUME_NONNULL_END

#endif /* SkeletonExtension_h */

