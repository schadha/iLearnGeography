//
//  EasyQuizViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/24/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EasyQuizViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

// Image for the country
@property (nonatomic, strong) IBOutlet UIImageView *countryImage;

// UIPickerView to select the continent
@property (nonatomic, strong) IBOutlet UIPickerView *continentPicker;

// Name for the country shown in the image
@property (nonatomic, strong) IBOutlet UILabel *countryName;

// Timer that counts down from 1 minute
@property (nonatomic, strong) IBOutlet UILabel *timerLabel;

// Dictionary and array representing the countries
@property (strong, nonatomic) NSDictionary *countriesDictionary;
@property (strong, nonatomic) NSMutableArray *countries;

// Handler for the Submit button
- (IBAction)submitAnswer:(UIButton *)sender;

@end
