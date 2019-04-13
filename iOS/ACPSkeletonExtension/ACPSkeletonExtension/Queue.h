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

#ifndef Queue_h
#define Queue_h

#import <Foundation/Foundation.h>
#import "ACPExtensionEvent.h"

/**
 * Queue used to hold events recieved by the extension's listener. The queue is used to hold events for later
 * processing if, at the time the event is received, specific required data is not available to process the event.
 */
@interface Queue : NSObject

/**
 * Add an `ACPExtensionEvent` to the queue.
 */
- (void)add:(nonnull ACPExtensionEvent*)event;

/**
 * Retrieve the `ACPExtensionEvent` at the top of the queue without removing it.
 * `Queue::hasNext` must be called before calling this method to ensure there exists at least one element in the queue.
 */
- (ACPExtensionEvent*) peek;

/**
 * Retrieve and remove the `ACPExtensionEvent` at the top of the queue.
 * `Queue::hasNext` must be called before calling this method to ensure there exists at least one element in the queue.
 */
- (ACPExtensionEvent*) poll;

/**
 * Check if there is at least one element in the queue.
 */
- (bool) hasNext;

@end

#endif /* Queue_h */
