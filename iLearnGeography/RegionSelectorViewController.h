//
//  RegionSelectorViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/27/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface RegionSelectorViewController : UIViewController<UIPickerViewDelegate>

// Table view that contains the continents

@property (strong, nonatomic) IBOutlet UIPickerView *regionPicker;

// Picked region name and index that is passed to the view controller by segue
@property (nonatomic, strong) NSString *pickedRegion;
@property (nonatomic, strong) NSNumber *regionIndex;

// Dictionary representing the Hard Quiz sections user information (scores)
@property (nonatomic, strong) NSMutableDictionary *sectionInfo;

@end
