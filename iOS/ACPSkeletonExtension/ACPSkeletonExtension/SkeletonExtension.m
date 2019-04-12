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
static NSString* ACP_STATE_OWNER = @"stateowner";
static NSString* ACP_CONFIGURATION_SHARED_STATE = @"com.adobe.module.configuration";

#pragma mark - Extension methods
- (nullable NSString *) name {
    return @"com.sample.acp.extension";
}

- (NSString *) version {
    return @"1.0.0";
}

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

- (void) onUnregister {
    [super onUnregister];
    
    // the extension was unregistered
    // if the shared states are not used in the next registration they can be cleared in this method
    [[self api] clearSharedEventStates:nil];
}

- (void) unexpectedError:(NSError *)error {
    [super unexpectedError:error];
    [ACPCore log:ACPMobileLogLevelError tag:LOG_TAG message:[NSString stringWithFormat:@"An unexpected error occurred: %@", error.localizedDescription ?: @"unknown"]];
}

- (void) queueEvent: (ACPExtensionEvent*) event {
    if (!event) {
        return;
    }
    
    [self.eventQueue add:event];
}

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
