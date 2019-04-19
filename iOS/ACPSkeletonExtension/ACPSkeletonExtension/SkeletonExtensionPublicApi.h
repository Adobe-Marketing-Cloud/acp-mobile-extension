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

#ifndef SkeletonExtensionPublicApi_h
#define SkeletonExtensionPublicApi_h

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Class defining interface between Mobile SDK Extension and application.
 * The Extension Public API class acts as the interface between the application and the Mobile SDK Extension.
 * Add methods here which the application can make requests of and retrieve data from the Mobile SDK Extension.
 */
@interface SkeletonExtensionPublicApi : NSObject

#pragma mark - Extension Public API methods


/**
 * Registers the Extension with the ACPCore in order to receive and dispatch new events
 * though the internal Event Hub. This method should be called once, when the application is initialized
 * in the AppDelegate.m class
 */
+ (void) registerExtension;

/**
 * Example of requesting information from the extension asynchronously. The most common use case is for public getters.
 */
+ (void) getterExample:(nullable void (^) (NSString * __nullable data))callback;

/**
 * Example of sending data to the extension asynchronously. The most common use case is for public setters.
 */
+ (void) setterExample:(NSString *) data;

@end

NS_ASSUME_NONNULL_END


#endif /* SkeletonExtensionPublicApi_h */
