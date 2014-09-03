//
//  DetailViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface DetailViewController : UIViewController<UIAlertViewDelegate>

// Method that reveals the menu when the Menu button is tapped
- (void)revealMenu:(id)sender;

// The row number for the section cell tapped
@property (nonatomic, strong) NSNumber *sectionRow;

// Name of the storyboard to load based on the section tapped
@property (nonatomic, strong) NSString *storyboardName;

// Delegate that allows access to the reloadTableData in the MenuViewController
// method to be called
@property (nonatomic, strong) id Delegate;

@end
