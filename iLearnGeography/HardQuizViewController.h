//
//  HardQuizViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/27/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface HardQuizViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *label;

// The PanGestureRecognizer handler that hanndles the dragging gesture for each puzzle piece.
- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer;

// Sets up the dictionary for each country's label location
@property (strong, nonatomic) NSDictionary *countriesCoordinatesDictionary;
@property (strong, nonatomic) NSMutableArray *countries;

// The selected continent's name and index
@property (strong, nonatomic) NSString *selectedRegion;
@property (strong, nonatomic) NSNumber *regionIndex;

@end
