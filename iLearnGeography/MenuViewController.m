//
//  MenuViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController ()

// Array representing the section names in the table view
@property (strong, nonatomic) NSMutableArray *sectionNames;

@end

@implementation MenuViewController

- (void)viewDidLoad {

    // set the sliding view parameters
    [self.slidingViewController setAnchorRightRevealAmount:255.0f];
    
    //set the menuView size = left layout width instead of full screen size
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    // Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set the local instance variable to the obj ref of the dict_section_images dictionary
    // data structure created in the App Delegate class
    self.dict_Section_images = appDelegate.sectionData;
    
    // Section names in order because a dictionary does not have an order for its keys
    self.sectionNames = [[NSMutableArray alloc] initWithObjects: @"Jigsaw Puzzle", @"Study Section", @"Easy Quiz", @"Medium Quiz", @"Hard Quiz", @"Bonus Quiz", @"Facts Section", nil];
    
    // Setup the table view
    [self.tableView setBackgroundColor:[[UIColor alloc] initWithRed:0.26 green:0.75 blue:0.93 alpha:1.0]];
    [self.tableView setSeparatorColor:[[UIColor alloc] initWithRed:0.12 green:0.65 blue:0.87 alpha:1.0]];
    [self.tableView setRowHeight:60];
    
    [super viewDidLoad];   // Inform super
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source Methods

// Asks the data source to return the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

// Asks the data source to return the number of rows in a section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionNames count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    // Obtain the object reference of the UITableViewCell object instantiated with respect to
    // the identifier TableViewCellReuseID
    SectionCell *cell = (SectionCell *)[tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseID"];
    
    // Sets the row name and font of the table view cell label
    NSString *rowName = [self.sectionNames objectAtIndex:rowNumber];
    cell.sectionLabel.text = rowName;
    cell.sectionLabel.font = [UIFont systemFontOfSize:20];
    
    // Sets the background and text color of the cell
    [cell setBackgroundColor:[[UIColor alloc] initWithRed:0.26 green:0.75 blue:0.93 alpha:1.0]];
    [cell.sectionLabel setTextColor:[UIColor whiteColor]];
    
    /*
     Sets the image for each cell based on what section name it is.
     Quizzes:
        -Numerator is score in plist.
        -Denominator is 40 or 50 depending on what type of quiz.
     All other cells will have a red or green dot.
     */
    NSString *cellImageFileName;
    NSArray *hardQuizInfo;
    NSInteger arraySum;
    if (![rowName isEqualToString:@"Hard Quiz"])
        cellImageFileName = [self.dict_Section_images objectForKey:rowName];
    else
    {
        hardQuizInfo = [self.dict_Section_images objectForKey:rowName];
        arraySum = [self sumOfArray:hardQuizInfo];
    }
    
    if  ([rowName hasSuffix:@"Quiz"])
    {
        [cell.numeratorLabel setHidden:NO];
        [cell.denominatorLabel setHidden:NO];
        
        if ([rowName hasPrefix:@"Hard"])
        {
            cell.numeratorLabel.text = [NSString stringWithFormat:@"%ld", (long)arraySum];
        }
        else {
            if (![cellImageFileName isEqualToString:@"green-dot"])
            {
                cell.sectionImage.image = [UIImage imageNamed:@"fractionbar.png"];
                cell.numeratorLabel.text = cellImageFileName;
            }
            else
            {
                [cell.numeratorLabel setHidden:YES];
                [cell.denominatorLabel setHidden:YES];
                cell.sectionImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cellImageFileName]];
            }
        }
        if (![rowName hasPrefix:@"Bonus"])
            cell.denominatorLabel.text = @"40";
        else
            cell.denominatorLabel.text = @"50";
        
    }
    else
        cell.sectionImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cellImageFileName]];
    
    // Sets the background color when a cell is selected
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[UIColor alloc] initWithRed:0.12 green:0.65 blue:0.87 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

// Calculates the sum of the score for the Hard Quiz section
-(NSInteger)sumOfArray:(NSArray*)array
{
    NSInteger sum = 0;
    
    for (NSNumber *num in array)
    {
        sum += [num intValue];
    }
    
    return sum;
}

#pragma mark - Table View Delegate Methods

// Tells the delegate (=self) that the row specified under indexPath is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    
    // Pass data to DetailViewController
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    vc.sectionRow = [NSNumber numberWithInteger:rowNumber + 1];
    vc.Delegate = self;
    
    TopNavigationController *nav = (TopNavigationController *) self.slidingViewController.topViewController;
    [nav pushViewController:vc animated:NO];
    [self.slidingViewController resetTopView]; //Resets the sliding view after selecting
}

// Method to reload the menu's data
-(void)reloadTableData
{
    [self viewDidLoad];
    [self.tableView reloadData];
}

@end