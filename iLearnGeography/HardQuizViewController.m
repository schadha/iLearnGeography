//
//  HardQuizViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/27/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "HardQuizViewController.h"

@interface HardQuizViewController ()

@end

@implementation HardQuizViewController

static CGPoint lastTranslation;
static int cardNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets the minimum number of touches to activate the sliding view controller to 2
    // so gesture functionality in the view is not disturbed.
    self.slidingViewController.panGesture.minimumNumberOfTouches = 2;
    
    // Sets up the dictioanary
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"CountryInformation" ofType:@"plist"];
    self.countriesCoordinatesDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePath] objectForKey:self.selectedRegion];
    self.countries = [[NSMutableArray alloc] initWithArray:[self.countriesCoordinatesDictionary allKeys]];
    
    cardNumber = 0;
    [self shuffle];
    [self createNewLabel];
}

//Shuffles the array to create a random order in which the labels are displayed
- (void)shuffle
{
    NSUInteger count = [self.countries count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        uint16_t nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self.countries exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

// Creates a new label that the user drags on the correct country
- (void)createNewLabel
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(895, 157, 127, 60)];
    self.label.tag = cardNumber;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = [self.countries objectAtIndex:cardNumber];
    self.label.font = [UIFont boldSystemFontOfSize:20];
    self.label.backgroundColor = [UIColor colorWithRed:.882352941 green:.392156863 blue:.247058824 alpha:0.2];
    if ([self.label.text componentsSeparatedByString:@" "].count > 1) {
        if (![self.label.text isEqualToString:@"Papua New Guinea"])
            self.label.frame = CGRectMake(895, 157, 97, 60);
        
        self.label.numberOfLines = 2;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    [self.label setUserInteractionEnabled:YES];
    
    // Adds a pan gesture recognizer to the label
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    [self.label addGestureRecognizer:panRecognizer];
    
    // Adds the label to the view
    [self.view addSubview:self.label];
}

/*
 Method that changes the Sections plist for a specified key.
 Changes the value assocaiated with a key to the imageName.
 This allows for the cell to display that image specified.
 */
-(void)changeSectionData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    NSMutableDictionary *sections = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    NSArray *scoreArray = [sections objectForKey:@"Hard Quiz"];
    
    //Create Correct Score Array
    NSArray *scoreArrayResult = [self createScoreArray:scoreArray];
    
    [sections setValue:scoreArrayResult forKey:@"Hard Quiz"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}

// Creates the score array that represents the score for each section
-(NSArray *)createScoreArray:(NSArray *)scoreArray
{
    NSMutableArray *scoreArrayResult = [[NSMutableArray alloc] initWithArray:scoreArray copyItems:YES];
    NSInteger index = [self.regionIndex integerValue];
    [scoreArrayResult setObject:[NSNumber numberWithInt:cardNumber] atIndexedSubscript:index];
    
    return scoreArrayResult;
}

// Handles the panning for each label
- (void)handlePanning:(UIPanGestureRecognizer *)gesture {
    
    NSInteger labelIndex = [gesture.view tag];
    
    // Check if this is the first touch
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        // Store the initial touch so when we change positions we do not snap
        lastTranslation = [gesture locationInView:gesture.view];
        [self.view bringSubviewToFront:gesture.view];
        
    }
    
    CGPoint newCoord = [gesture locationInView:gesture.view];
    
    // Create the frame offsets to use our finger position in the view.
    float dX = newCoord.x-lastTranslation.x;
    float dY = newCoord.y-lastTranslation.y;
    
    gesture.view.frame = CGRectMake(gesture.view.frame.origin.x+dX,
                                    gesture.view.frame.origin.y+dY,
                                    gesture.view.frame.size.width,
                                    gesture.view.frame.size.height);
    
    // Delta Width and Height, Center X and YCoordinates of each label
    CGFloat dLabelWidth = gesture.view.frame.size.width/2;
    CGFloat dLabelHeight = gesture.view.frame.size.height/2;
    CGFloat labelCenterX = gesture.view.center.x;
    CGFloat labelCenterY = gesture.view.center.y;
    
    // The actual X and Y coordinate for that label
    NSInteger actualX = [[[[[self.countriesCoordinatesDictionary objectForKey:[self.countries objectAtIndex:labelIndex]] objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:0] integerValue];
    NSInteger actualY = [[[[[self.countriesCoordinatesDictionary objectForKey:[self.countries objectAtIndex:labelIndex]] objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
    
    // For loop constantly checks each X and Y coordinate
    for (int i = 0; i < self.countries.count; i++) {
        NSInteger eachX = [[[[[self.countriesCoordinatesDictionary objectForKey:[self.countries objectAtIndex:i]] objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:0] integerValue];
        NSInteger eachY = [[[[[self.countriesCoordinatesDictionary objectForKey:[self.countries objectAtIndex:i]] objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
        
        // If label is within 20 points of the X and Y coordinate, label will snap to it
        if (labelCenterX >= (eachX - 20) &&
            labelCenterX <= (eachX + 20) &&
            labelCenterY >= (eachY - 20) &&
            labelCenterY <= (eachY + 20))
        {
            gesture.view.frame = (CGRect){{eachX-dLabelWidth, eachY-dLabelHeight}, gesture.view.frame.size};
            
            if (gesture.view.frame.origin.x == actualX-dLabelWidth && gesture.view.frame.origin.y == actualY-dLabelHeight)
            {
                // Change label background to green when the label is in the correct location
                gesture.view.backgroundColor = [UIColor colorWithRed:.498039216 green:.882352941 blue:.341176471 alpha:0.2];
                if (cardNumber == labelIndex)
                {
                    cardNumber++;
                    if (cardNumber != [self.countries count])
                        [self createNewLabel]; // Create a new label only if the label is in the correct position and it isn't the last label
                    else
                    {
                        [self changeSectionData];
                        
                    }
                }
            }
            else
            {
                // Change label background to red when the label is not in the correct location
                gesture.view.backgroundColor = [UIColor colorWithRed:.882352941 green:.392156863 blue:.247058824 alpha:0.2];
            }
            if (gesture.state == UIGestureRecognizerStateEnded && cardNumber == [self.countries count])
            {
                // Show an alert to choose another region after all labels have been placed correctly
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Nice Job!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Select Another Region"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

// View is popped off to select another region
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
