//
//  RegionSelectorViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/27/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "RegionSelectorViewController.h"
#import "HardQuizViewController.h"

@interface RegionSelectorViewController ()

@end

@implementation RegionSelectorViewController

static NSArray *continents;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets the minimum number of touches to activate the sliding view controller to 2
    // so gesture functionality in the view is not disturbed.
    self.slidingViewController.panGesture.minimumNumberOfTouches = 2;
    
    continents = [[NSArray alloc] initWithObjects:@"Asia", @"Africa", @"Europe", @"Oceania", @"North America", @"South America", nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Sets the minimum number of touches to activate the sliding view controller to 2
    // so gesture functionality in the view is not disturbed.
    self.slidingViewController.panGesture.minimumNumberOfTouches = 2;
    [self.regionPicker reloadAllComponents];
}



#pragma mark - Picker View delegate methods
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 30, 30)];
    NSString*imageName = [self parseScoreArray:row];
    imgView.image = [UIImage imageNamed:imageName];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 60)];
    label.text = [continents objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [tmpView insertSubview:imgView atIndex:0];
    [tmpView insertSubview:label atIndex:0];
    
    return tmpView;
}

// Parses the score array to set the image for the table view cell
-(NSString *)parseScoreArray:(NSInteger) row
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    NSMutableDictionary *sections = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    NSArray *scoreArray = [sections objectForKey:@"Hard Quiz"];
    NSNumber *score = [scoreArray objectAtIndex:row];
    
    // Switch case that returns the image name if the score is a specific number for an index in the scores array
    switch (row) {
        case 0:
            if ([score intValue] == 6)
                return @"green-dot";
            break;
        case 1:
            if ([score intValue] == 10)
                return @"green-dot";
            break;
        case 2:
            if ([score intValue] == 12)
                return @"green-dot";
            break;
        case 3:
            if ([score intValue] == 3)
                return @"green-dot";
            break;
        case 4:
            if ([score intValue] == 4)
                return @"green-dot";
            break;
        case 5:
            if ([score intValue] == 5)
                return @"green-dot";
            break;
        default:
            break;
    }
    
    return @"red-dot";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return continents.count;
}

// Perform segue based on the selected table cell
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Component: %ld\n", (long)component);
    self.pickedRegion =  [continents objectAtIndex:[self.regionPicker selectedRowInComponent:0]];
    self.regionIndex = [NSNumber numberWithInteger:row];
    [self performSegueWithIdentifier:self.pickedRegion sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        HardQuizViewController *viewController = [segue destinationViewController];
        viewController.selectedRegion = self.pickedRegion;
        viewController.regionIndex = self.regionIndex;
}

@end
