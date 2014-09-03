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



#pragma mark - Table View delegate methods
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Set up cell
//    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regionCell"];
//    cell.textLabel.text = [continents objectAtIndex:[indexPath row]];
//    cell.textLabel.font = [UIFont systemFontOfSize:22];
//    cell.backgroundColor = [[UIColor alloc] initWithRed:.556862745 green:.831372549 blue:.905882353 alpha:1];
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
//    NSString*imageName = [self parseScoreArray:[indexPath row]];
//    imgView.image = [UIImage imageNamed:imageName];
//    cell.imageView.image = imgView.image;
//    
//    return cell;
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    NSString*imageName = [self parseScoreArray:row];
    imgView.image = [UIImage imageNamed:imageName];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, -5, 80, 60)];
    label.text = [continents objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor alloc] initWithRed:.556862745 green:.831372549 blue:.905882353 alpha:1];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 60)];
    [tmpView insertSubview:imgView atIndex:0];
    [tmpView insertSubview:label atIndex:1];
    
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

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return continents.count;
//}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return continents.count;
}

// Perform segue based on the selected table cell
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickedRegion =  [continents objectAtIndex:[self.regionPicker selectedRowInComponent:1]];
    self.regionIndex = [NSNumber numberWithInt:row];
    [self performSegueWithIdentifier:self.pickedRegion sender:self];
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.pickedRegion = [[[self.regionPicker cellForRowAtIndexPath:indexPath] textLabel]text];
//    self.regionIndex = [NSNumber numberWithInt:[indexPath row]];
//    [self performSegueWithIdentifier:self.pickedRegion sender:self];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        HardQuizViewController *viewController = [segue destinationViewController];
        viewController.selectedRegion = self.pickedRegion;
        viewController.regionIndex = self.regionIndex;
}

@end
