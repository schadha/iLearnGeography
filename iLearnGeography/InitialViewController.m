//
//  ViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end


@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *storyboard;
    
    // Main storyboard loaded
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (storyboard)
    {
        // Instantiate and set the top view controller as the initial controller.
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"TopView"];
        
        // Adds a pan gesture recognizer for the slide view to work.
        self.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end