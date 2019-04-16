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

#import "ViewController.h"
#import "SkeletonExtensionPublicAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)setDataToExtension:(id)sender {
    [self.txtSetterData resignFirstResponder];
    NSString* setData = _txtSetterData.text;
    
    [SkeletonExtensionPublicApi setRequestToExtension:setData];
}

- (IBAction)getDataFromExtension:(id)sender {
    [SkeletonExtensionPublicApi getRequestFromExtension:^(NSString * _Nullable data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
                self.lblExtensionData.text = data;
            }
        });
    }];
}


@end
