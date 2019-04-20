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

#ifndef SkeletonExtensionConstants_h
#define SkeletonExtensionConstants_h

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const EVENT_TYPE_EXTENSION;
FOUNDATION_EXPORT NSString *const EVENT_SOURCE_EXTENSION_REQUEST_CONTENT;
FOUNDATION_EXPORT NSString *const EVENT_SOURCE_EXTENSION_RESPONSE_CONTENT;

FOUNDATION_EXPORT NSString *const EVENT_TYPE_ADOBE_HUB;
FOUNDATION_EXPORT NSString *const EVENT_SOURCE_ADOBE_SHARED_STATE;

FOUNDATION_EXPORT NSString *const EVENT_SETTER_REQUEST_DATA_KEY;
FOUNDATION_EXPORT NSString *const EVENT_GETTER_RESPONSE_DATA_KEY;

FOUNDATION_EXPORT NSString *const SHARED_STATE_OWNER;
FOUNDATION_EXPORT NSString *const SHARED_STATE_CONFIGURATION;
FOUNDATION_EXPORT NSString *const SHARED_STATE_SAMPLE_CONFIG_KEY;

#endif /* SkeletonExtensionConstants_h */
