//
//  StudySectionViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/21/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StudySectionViewController : UIViewController

// Image for the country
@property (nonatomic, strong) IBOutlet UIImageView *countryImage;

// Labels for the continent, country and flash card number
@property (nonatomic, strong) IBOutlet UILabel *continentName;
@property (nonatomic, strong) IBOutlet UILabel *countryName;
@property (nonatomic, strong) IBOutlet UILabel *cardNumber;

// Dictionary and array representing the countries
@property (strong, nonatomic) NSDictionary *countriesDictionary;
@property (strong, nonatomic) NSMutableArray *countries;

// Handler for the Random button
- (IBAction)randomFlashCard:(UIButton *)sender;
@end
