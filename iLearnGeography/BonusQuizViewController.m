//
//  BonusQuizViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 12/7/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "BonusQuizViewController.h"

@interface BonusQuizViewController ()

@end

@implementation BonusQuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets up the dictionary
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"UnitedStates" ofType:@"plist"];
    self.statesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePath];
    self.states = [self.statesDictionary allKeys];
    
    // Creates the state labels to be placed on the United States map
    [self createLabels];
    
    // Sets the first row to be selected by the picker view
    [self.statePicker selectRow:0 inComponent:0 animated:NO];
}

/*
 Creates the labels for each state. Labels are two letter codes for each state
 and are initialized to be hidden. When the correct state is tapped, these
 labels are unhidden.
 */
- (void)createLabels
{
    NSMutableArray *stateNames = [[NSMutableArray alloc] initWithCapacity:50];
    NSMutableArray *stateLabels = [[NSMutableArray alloc] initWithCapacity:50];
    
    for (int i = 0; i < 50; i++) {
        NSString *stateKey = [self.states objectAtIndex:i];
        NSArray *stateInfo = [self.statesDictionary objectForKey:stateKey];
        [stateNames addObject:[stateInfo objectAtIndex:0]];
        
        // X and Y coordinate for the label
        NSInteger xCoordinate = [[[[stateInfo objectAtIndex:1] componentsSeparatedByString:@","] objectAtIndex:0] integerValue];
        NSInteger yCoordinate = [[[[stateInfo objectAtIndex:1] componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
        
        // Create the label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xCoordinate, yCoordinate, 28, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = stateKey;
        [label setHidden:YES];
        [stateLabels addObject:label];
        
        // Create the red dot for each state
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(xCoordinate, yCoordinate, 25, 25)];
        [image setTag:i];
        [image setImage:[UIImage imageNamed:@"red-dot.png"]];
        [image setUserInteractionEnabled:YES];
         
        // Add the tap gesture recognizer for each red dot
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleSingleTap:)];
        [image addGestureRecognizer:singleTap];
        
        // Adds each label and red dot to the view
        [self.view addSubview:image];
        [self.view addSubview:label];
    }
    
    self.stateNames = [stateNames sortedArrayUsingSelector:@selector(compare:)];
    self.stateLabels = stateLabels;
}

// Handles a tap on the red dot. If the dot matches the state selected by the picker view
// the dot dissappears and is replaced by the two letter code of the state
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
 
    UIImageView *stateImage = (UIImageView *)gestureRecognizer.view;
    NSInteger index = [stateImage tag];
    UILabel *stateLabel = [self.stateLabels objectAtIndex:index];
    NSString *stateNameTapped = [[self.statesDictionary objectForKey:stateLabel.text] objectAtIndex:0];
    NSInteger stateNamePickedIndex = [self.statePicker selectedRowInComponent:0];
    NSString *stateNamePicked = [self.stateNames objectAtIndex:stateNamePickedIndex];
    
    if ([stateNameTapped isEqualToString:stateNamePicked]) {
        
        [stateImage setHidden:YES];
        [stateLabel setHidden:NO];
        if (stateNamePickedIndex != 49)
        {
            [self changeSectionData:[NSString stringWithFormat:@"%ld", (long)stateNamePickedIndex+1]];
            [self.statePicker selectRow:(++stateNamePickedIndex) inComponent:0 animated:YES];
        }
        else if (stateNamePickedIndex == 49)
        {
            [self changeSectionData:@"green-dot"];
            
            // Alertview when all states have been identified correctly
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Nice Job! You got all 50 states!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

/*
Method that changes the Sections plist for a specified key.
Changes the value assocaiated with a key to the imageName.
This allows for the cell to display that image specified.
*/
-(void)changeSectionData:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    NSMutableDictionary *sections = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    [sections setValue:imageName forKey:@"Bonus Quiz"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}
         
#pragma mark - Picker View Delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.stateNames.count;
}

// Sets up the label view for each cell in the picker view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:30];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text = [self.stateNames objectAtIndex:row];
    }
    return tView;
}


@end
