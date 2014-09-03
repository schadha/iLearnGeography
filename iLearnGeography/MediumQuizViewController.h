//
//  MediumQuizViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/25/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MediumQuizViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

// UIPickerView for the country that is going to be selected
@property (nonatomic, strong) IBOutlet UIPickerView *countryPicker;

// Timer that counts down from 1 minute
@property (nonatomic, strong) IBOutlet UILabel *timerLabel;

// Image views representing each continent so the user has a larger area to tap on
@property (nonatomic, strong) IBOutlet UIImageView *Asia;
@property (nonatomic, strong) IBOutlet UIImageView *Europe;
@property (nonatomic, strong) IBOutlet UIImageView *Africa;
@property (nonatomic, strong) IBOutlet UIImageView *Oceania;
@property (nonatomic, strong) IBOutlet UIImageView *South_America;
@property (nonatomic, strong) IBOutlet UIImageView *North_America;

// Map pins dropped onto each continent
@property (nonatomic, strong) IBOutlet UIImageView *AsiaPin;
@property (nonatomic, strong) IBOutlet UIImageView *EuropePin;
@property (nonatomic, strong) IBOutlet UIImageView *AfricaPin;
@property (nonatomic, strong) IBOutlet UIImageView *OceaniaPin;
@property (nonatomic, strong) IBOutlet UIImageView *South_AmericaPin;
@property (nonatomic, strong) IBOutlet UIImageView *North_AmericaPin;

// Dictionary and array for picker view
@property (strong, nonatomic) NSDictionary *countriesDictionary;
@property (strong, nonatomic) NSMutableArray *countries;

@end
