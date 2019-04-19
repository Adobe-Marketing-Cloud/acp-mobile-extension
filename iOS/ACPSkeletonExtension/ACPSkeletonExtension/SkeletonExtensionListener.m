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

@implementation SkeletonExtensionListener

- (void) hear:(ACPExtensionEvent *)event {
    [ACPCore log:ACPMobileLogLevelDebug tag:@"SkeletonExtensionListener" message:[NSString stringWithFormat:@"Heard an event: %@, %@.  Data: %@", event.eventName, event.eventType, event.eventData]];
    SkeletonExtension* parentExtension = [self getParentExtension];
    if (parentExtension == nil) {
        [ACPCore log:ACPMobileLogLevelWarning tag:@"SkeletonExtensionListener" message:@"Unable to process event, the parent extension was nil."];
        return;
    }
    
    // handle SharedState events
    if ([event.eventType isEqualToString:EVENT_TYPE_ADOBE_HUB]) {
        if ([event.eventData[SHARED_STATE_OWNER] isEqualToString:SHARED_STATE_CONFIGURATION]) {
            dispatch_async([parentExtension dispatchQueue], ^{
                [parentExtension processEvents];
            });
        }
    }
    
    // handle Extension events
    else if ([event.eventType isEqualToString:EVENT_TYPE_EXTENSION]) {
        dispatch_async([parentExtension dispatchQueue], ^{
            [parentExtension queueEvent:event];
            [parentExtension processEvents];
        });
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
