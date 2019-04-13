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
#import "SkeletonExtensionListener.h"
#import "Queue.h"

@interface SkeletonExtension()
@property (nonatomic, strong) Queue *eventQueue;
@end

@implementation SkeletonExtension

static NSString* LOG_TAG = @"SkeletonExtension";
static NSString* ACP_STATE_OWNER = @"stateowner"; // EventData key for shared state owner from events of type hub and source shared state
static NSString* ACP_CONFIGURATION_SHARED_STATE = @"com.adobe.module.configuration"; // Configuration extension shared state owner name

#pragma mark - Extension methods
/* Required override, each extension must have a unique name within the application. */
- (nullable NSString *) name {
    return @"com.sample.acp.extension";
}

/* Optional override, the version of this extension. */
- (NSString *) version {
    return @"1.0.0";
}

/**
 * Initialize the extension. Register event listeners here. The example below uses the same `SkeletonExtensionListener`
 * class to handles all interesting events, however separate listener classes may be used instead. It is recommended
 * to listen for each specific event the extension is interested in. Use of a wildcard listener is discuraged in
 * production systems.
 */
- (instancetype) init {
    if (self = [super init]) {
        NSError *error = nil;
        
        // register a listener for shared state changes
        if ([self.api registerListener:[SkeletonExtensionListener class]
                             eventType:@"com.adobe.eventType.hub"
                           eventSource:@"com.adobe.eventSource.sharedState"
                                 error:&error]) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:@"ExtensionListener successfully registered for Event Hub Shared State events"];
        } else {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"There was an error registering ExtensionListener for Event Hub Shared State events: %@", error.localizedDescription ?: @"unknown"]];
        }
        
        // register a listener for Extension request events
        error = nil;
        if ([self.api registerListener:[SkeletonExtensionListener class]
                             eventType:@"com.sample.acp.eventType.skeletonExtension"
                           eventSource:@"com.sample.acp.eventSource.requestContent"
                                 error:&error]) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:@"ExtensionListener successfully registered for Extension Request Content events"];
        } else {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"There was an error registering ExtensionListener for Extension Request Content events: %@", error.localizedDescription ?: @"unknown"]];
        }
        
        // initialize the events queue
        self.eventQueue = [[Queue alloc] init];
    }
    
    return self;
}

/* Optional override to clean up any open resources. */
- (void) onUnregister {
    [super onUnregister];
    
    // the extension was unregistered
    // if the shared states are not used in the next registration they can be cleared in this method
    [[self api] clearSharedEventStates:nil];
}

/* Optional override but recommended to handle notifications of unexpected errors generated from the SDK. */
- (void) unexpectedError:(NSError *)error {
    [super unexpectedError:error];
    [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An unexpected error occurred: %@", error.localizedDescription ?: @"unknown"]];
}

/**
 * Called by `SkeletonExtensionListener`.
 */
- (void) queueEvent: (ACPExtensionEvent*) event {
    if (!event) {
        return;
    }
    
    [self.eventQueue add:event];
}

/**
 * Called by `SkeletonExtensionListener`.
 * In this example, the Configuration shared state is required (for example a network URL or a service key may be extracted).
 * If the Configuration shared state is `nil` it means the shared state is pending. The logic below will exit processing
 * the event queue if the Configuration shared state is not available. This extension registers a listener for events
 * of type `hub` and source `sharedState` to kick processing of queued events when a Configuration shared state is available.
 */
- (void) processEvents {
    while ([self.eventQueue hasNext]) {
        ACPExtensionEvent* eventToProcess = [self.eventQueue peek];
        
        NSError *error = nil;
        NSDictionary *configSharedState = [self.api getSharedEventState:ACP_CONFIGURATION_SHARED_STATE event:eventToProcess error:&error];
        
        // NOTE: configuration is mandatory processing the event, so if shared state is null stop processing events
        if (!configSharedState) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"%@ - Could not process event, configuration shared state is pending", [self name]]];
            return;
        }
        
        if (error != nil) {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"%@ - Could not process event, an error occured while retrieving configuration shared state %ld", [self name], [error code]]];
            return;
        }
        
        [self.eventQueue poll];
    }
}

@end
