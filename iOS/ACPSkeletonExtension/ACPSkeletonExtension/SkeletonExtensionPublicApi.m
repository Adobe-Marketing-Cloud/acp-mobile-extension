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
#import "SkeletonExtensionPublicApi.h"

@implementation SkeletonExtensionPublicApi

#pragma mark - Extension Public API methods

+ (void) registerExtension {
    NSError *error = nil;
    if ([ACPCore registerExtension:[SkeletonExtension class] error:&error]) {
        [ACPCore log:ACPMobileLogLevelDebug tag:@"SkeletonExtension" message:@"Extension was successfully registered"];
    } else {
        [ACPCore log:ACPMobileLogLevelError tag:@"SkeletonExtension" message:[NSString stringWithFormat:@"An error occurred while attempting to register Extension: %@", [error localizedDescription]]];
    }
}


@end
