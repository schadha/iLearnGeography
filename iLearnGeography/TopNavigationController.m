//
//  TopNavigationController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "TopNavigationController.h"

@interface TopNavigationController ()

@end

@implementation TopNavigationController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the shadow when the slide view is revealed
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

// Menu button action
-(void)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end