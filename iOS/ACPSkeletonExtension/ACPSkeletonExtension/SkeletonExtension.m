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
#import "SkeletonExtensionListener.h"
#import "Queue.h"

@interface SkeletonExtension()
@property (nonatomic, strong) Queue *eventQueue;
@property (nonatomic, copy) NSString *stateValue;
@end

@implementation SkeletonExtension

static NSString* LOG_TAG = @"SkeletonExtension";

#pragma mark - Extension methods
/* Required override, each extension must have a unique name within the application. */
- (nullable NSString *) name {
    return @"com.sample.company.skeletonextension";
}

/* Optional override, the version of this extension. */
- (NSString *) version {
    return @"1.0.0";
}

/**
 * Initialize the extension. Register event listeners here. The example below uses the same `SkeletonExtensionListener`
 * class to handles all interesting events, however separate listener classes may be used instead. It is recommended
 * to listen for each specific event the extension is interested in. Use of a wildcard listener is discouraged in
 * production environments.
 */
- (instancetype) init {
    if (self = [super init]) {
        NSError *error = nil;
        
        // register a listener for shared state changes
        if ([self.api registerListener:[SkeletonExtensionListener class]
                             eventType:EVENT_TYPE_ADOBE_HUB
                           eventSource:EVENT_SOURCE_ADOBE_SHARED_STATE
                                 error:&error]) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:@"ExtensionListener successfully registered for Event Hub Shared State events"];
        } else {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"There was an error registering ExtensionListener for Event Hub Shared State events: %@", error.localizedDescription ?: @"unknown"]];
        }
        
        // register a listener for Extension request events
        error = nil;
        if ([self.api registerListener:[SkeletonExtensionListener class]
                             eventType:EVENT_TYPE_EXTENSION
                           eventSource:EVENT_SOURCE_EXTENSION_REQUEST_CONTENT
                                 error:&error]) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:@"ExtensionListener successfully registered for Extension Request Content events"];
        } else {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"There was an error registering ExtensionListener for Extension Request Content events: %@", error.localizedDescription ?: @"unknown"]];
        }
        
        // initialize this extension's dispatch queue
        self.dispatchQueue = dispatch_queue_create([[self name] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        // initialize the events queue
        self.eventQueue = [[Queue alloc] init];
        
        self.stateValue = @"nil";
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
        NSDictionary *configSharedState = [self.api getSharedEventState:SHARED_STATE_CONFIGURATION event:eventToProcess error:&error];
        
        // NOTE: configuration is mandatory processing the event, so if shared state is null stop processing events
        if (!configSharedState) {
            [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"%@ - Could not process event, configuration shared state is pending", [self name]]];
            return;
        }
        
        if (error != nil) {
            [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"%@ - Could not process event, an error occured while retrieving configuration shared state %ld", [self name], [error code]]];
            return;
        }
        
        // example of extracting a configuration value.
        NSString *sampleConfigValue = configSharedState.count ? configSharedState[SHARED_STATE_SAMPLE_CONFIG_KEY] : @"";
        [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"Found sample configuration value of '%@'.", sampleConfigValue]];
        
        if (eventToProcess.eventData && [[eventToProcess eventData] objectForKey:EVENT_SETTER_REQUEST_DATA_KEY]) {
            [self processSetterRequestEvent:eventToProcess];
        } else {
            [self processGetterRequestEvent:eventToProcess];
        }
        
        [self.eventQueue poll];
    }
}

- (void) processGetterRequestEvent:(ACPExtensionEvent*) requestEvent {
    NSDictionary* responseData = @{EVENT_GETTER_RESPONSE_DATA_KEY: self.stateValue};
    NSError* eventError = nil;
    ACPExtensionEvent *responseEvent = [ACPExtensionEvent extensionEventWithName:@"Get Data Example"
                                                                            type:EVENT_TYPE_EXTENSION
                                                                          source:EVENT_SOURCE_EXTENSION_RESPONSE_CONTENT
                                                                            data:responseData
                                                                           error:&eventError];
    if (!responseEvent) {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred constructing event '%@': %@", requestEvent.eventName, eventError.localizedDescription ?: @"unknown"]];
        /* Even though the response event is nil, continue to call ACPCore::dispatchResponseEvent as a response still needs
            to be dispatched to the waiting paired listener.
         */
    }
    
    // dispatch the response for the public API
    NSError *dispatchError = nil;
    if ([ACPCore dispatchResponseEvent:responseEvent requestEvent:requestEvent error:&dispatchError]) {
        [ACPCore log:ACPMobileLogLevelDebug tag:LOG_TAG message:[NSString stringWithFormat:@"Dispatched an event '%@'", responseEvent.eventName]];
    } else {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"%@ - An error occurred dispatching event '%@': %@", [self name], responseEvent.eventName, dispatchError.localizedDescription ?: @"unknown"]];
    }
}

- (void) processSetterRequestEvent:(ACPExtensionEvent*) requestEvent {
    self.stateValue = requestEvent.eventData[EVENT_SETTER_REQUEST_DATA_KEY];
    NSDictionary* extensionState = @{EVENT_SETTER_REQUEST_DATA_KEY: self.stateValue};
    
    // save new data to extension's shared state making it available for other extensions
    // and as a data element for rules processing
    NSError *setSharedStateError = nil;
    if (![[self api] setSharedEventState:extensionState event:requestEvent error:&setSharedStateError] && setSharedStateError != nil) {
        [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An error occurred while setting the shared state %@, error code %ld", extensionState, [setSharedStateError code]]];
    }
    
}

@end
