//
//  BonusQuizViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 12/7/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BonusQuizViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

// Dictionary containing all the states
@property (strong, nonatomic) NSDictionary *statesDictionary;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSArray *stateNames;
@property (strong, nonatomic) NSArray *stateLabels;

// UIPickerView that selects a random state for the user
@property (strong, nonatomic) IBOutlet UIPickerView *statePicker;

@end
