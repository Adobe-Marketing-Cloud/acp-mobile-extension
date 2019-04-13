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

#import "ACPExtension.h"

NS_ASSUME_NONNULL_BEGIN

// A custom extension must inherit from the ACPExtension class, which can be found in ACPCore library
@interface SkeletonExtension : ACPExtension

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

