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

#import "ACPCore.h"
#import "SkeletonExtension.h"
#import "SkeletonExtensionConstants.h"
#import "SkeletonExtensionPublicApi.h"

@implementation SkeletonExtensionPublicApi

static NSString* LOG_TAG = @"SkeletonExtension";

#pragma mark - Extension Public API methods

+ (void) registerExtension {
    NSError *error = nil;
    if ([ACPCore registerExtension:[SkeletonExtension class] error:&error]) {
        [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:@"Extension was successfully registered"];
    } else {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred while attempting to register Extension: %@", [error localizedDescription]]];
    }
}

+ (void) getterExample:(nullable void (^) (NSString * __nullable data))callback {
    if (!callback) {
        [ACPCore log:ACPMobileLogLevelWarning tag:LOG_TAG message:@"Cannot make request if callback is nil."];
        return;
    }
    
    // create the request event
    NSError *eventError = nil;
    ACPExtensionEvent *requestEvent = [ACPExtensionEvent extensionEventWithName:@"Get Data Example"
                                                                           type:EVENT_TYPE_EXTENSION
                                                                         source:EVENT_SOURCE_EXTENSION_REQUEST_CONTENT
                                                                           data:nil
                                                                          error:&eventError];
    if (!requestEvent) {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred constructing event '%@': %@", requestEvent.eventName, eventError.localizedDescription ?: @"unknown"]];
        callback(nil);
        return;
    }
    
    // dispatch the event and handle the callback
    NSError *dispatchError = nil;
    if ([ACPCore dispatchEventWithResponseCallback:requestEvent responseCallback:^(ACPExtensionEvent * _Nonnull responseEvent) {
        NSString *extensionData = responseEvent.eventData[EVENT_GETTER_RESPONSE_DATA_KEY];
        callback(extensionData);
    } error:&dispatchError]) {
        [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"Dispatched an event '%@'", requestEvent.eventName]];
    } else {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred dispatching event '%@': %@", requestEvent.eventName, dispatchError.localizedDescription ?: @"unknown"]];
    }
}

+ (void) setterExample:(NSString *) data {
    NSDictionary* requestData = @{EVENT_SETTER_REQUEST_DATA_KEY:data};
    
    // create the request event
    NSError *eventError = nil;
    ACPExtensionEvent *requestEvent = [ACPExtensionEvent extensionEventWithName:@"Set Data Example"
                                                                           type:EVENT_TYPE_EXTENSION
                                                                         source:EVENT_SOURCE_EXTENSION_REQUEST_CONTENT
                                                                           data:requestData
                                                                          error:&eventError];
    if (!requestEvent) {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred constructing event '%@': %@", requestEvent.eventName, eventError.localizedDescription ?: @"unknown"]];
        return;
    }
    
    // dispatch the event
    NSError *dispatchError = nil;
    if ([ACPCore dispatchEvent:requestEvent error:&dispatchError]) {
        [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"Dispatched an event '%@'", requestEvent.eventName]];
    } else {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred dispatching event '%@': %@", requestEvent.eventName, dispatchError.localizedDescription ?: @"unknown"]];
    }
}

@end
