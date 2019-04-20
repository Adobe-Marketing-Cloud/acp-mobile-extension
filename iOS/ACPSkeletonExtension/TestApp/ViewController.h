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

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet UILabel *lblExtensionData;
@property (nonatomic, assign) IBOutlet UITextField *txtSetterData;
@property (nonatomic, assign) IBOutlet UIButton *btnSetter;
@property (nonatomic, assign) IBOutlet UIButton *btnGetter;

- (IBAction) setDataToExtension:(id)sender;
- (IBAction) getDataFromExtension:(id)sender;

@end

