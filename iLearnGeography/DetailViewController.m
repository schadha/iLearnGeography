//
//  DetailViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the Menu button on the left side of the Navigation Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(revealMenu:)];
    
    // Create the Reset Data button on the right side of the Navigation Bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset Data" style:UIBarButtonItemStylePlain target:self action:@selector(resetData)];
    
    // Switch case to select the name of the storyboard to load.
    switch ([self.sectionRow integerValue]) {
        case 0:
            self.storyboardName = @"Main";
            break;
        case 1:
            self.storyboardName = @"JigsawPuzzleEasy";
            break;
        case 2:
            self.storyboardName = @"StudySection";
            break;
        case 3:
            self.storyboardName = @"EasyQuiz";
            break;
        case 4:
            self.storyboardName = @"MediumQuiz";
            break;
        case 5:
            self.storyboardName = @"HardQuiz";
            break;
        case 6:
            self.storyboardName = @"BonusQuiz";
            break;
        case 7:
            self.storyboardName = @"FactsSection";
            break;
        default:
            break;
    }
    
    if (![self.storyboardName isEqualToString:@"Main"])
    {
        // Get the storyboard named self.storyboardName from the main bundle:
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:self.storyboardName bundle:nil];
        
        // Load the initial view controller from the storyboard.
        UIViewController *viewController = [storyBoard instantiateInitialViewController];
        
        // Then push the new view controller in the usual way:
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the minimum touches required to reveal the slide controller
    self.slidingViewController.panGesture.minimumNumberOfTouches = 1;
    
    // Shows a shadow when the slide view is shown
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    // Data in the menu view is reloaded
    SEL selector = NSSelectorFromString(@"reloadTableData");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.Delegate performSelector:selector withObject:NULL];
#pragma clang diagnostic pop
}

// Menu button action
-(void)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
}

// Existing plist is removed and is replaced by the one existing in the main bundle.
-(void)resetData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistFilePathInDocumentsDirectory error:NULL];
    
    NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"Sections" ofType:@"plist"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
    NSMutableDictionary *sectionData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    appDelegate.sectionData = sectionData;
    [sectionData writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    
    
    SEL selector = NSSelectorFromString(@"reloadTableData");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.Delegate performSelector:selector withObject:NULL];
#pragma clang diagnostic pop
    
    // Alert that informs that the data has been reset.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Data"
                                                    message:@"Data has been reset."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
