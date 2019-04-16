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

@implementation SkeletonExtensionListener

- (void) hear:(ACPExtensionEvent *)event {
    [ACPCore log:ACPMobileLogLevelDebug tag:@"SkeletonExtensionListener" message:[NSString stringWithFormat:@"Heard an event: %@, %@.  Data: %@", event.eventName, event.eventType, event.eventData]];
    SkeletonExtension* parentExtension = [self getParentExtension];
    if (parentExtension == nil) {
        [ACPCore log:ACPMobileLogLevelWarning tag:@"SkeletonExtensionListener" message:@"The parent extension was nil, skipping event"];
        return;
    }
    
    // handle SharedState events
    if ([event.eventType isEqualToString:@"com.adobe.eventType.hub"]) {
        if ([event.eventData[@"stateowner"] isEqualToString:@"com.adobe.module.configuration"]) {
            [parentExtension processEvents];
        }
    }
    
    // handle Extension events
    else if ([event.eventType isEqualToString:@"com.sample.company.eventType.skeletonExtension"]) {
        [parentExtension queueEvent:event];
        [parentExtension processEvents];
    }
    
}

/**
 * Returns the extension which registered this listener.
 */
- (SkeletonExtension*) getParentExtension {
    SkeletonExtension* parentExtension = nil;
    if ([[self extension] isKindOfClass:SkeletonExtension.class]) {
        parentExtension = (SkeletonExtension*) [self extension];
    }
    
    return parentExtension;
}

@end
