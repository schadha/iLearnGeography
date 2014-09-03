//
//  AppDelegate.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Dictionary representing the data for each section. Saved in the application's documents directory
@property (strong, nonatomic) NSMutableDictionary *sectionData;

@end
