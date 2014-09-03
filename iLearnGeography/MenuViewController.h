//
//  MenuViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "TopNavigationController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "SectionCell.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// The dictionary representing the sections for the application.
@property (strong, nonatomic) NSDictionary *dict_Section_images;

// The tableview that is shown when the view is panned to the right.
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
