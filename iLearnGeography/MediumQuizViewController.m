//
//  MediumQuizViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/25/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "MediumQuizViewController.h"

@interface MediumQuizViewController ()

@end

@implementation MediumQuizViewController

static int cardNumber = 0;
static int totalScore = 0;
static bool isFirstTap = YES;
static NSMutableArray *countriesForPicker;
static NSArray *continents;
static NSMutableArray *continentPins;
static UIImageView *continentPin;

/*
 Initializers for the timer. The timer has a format of 01:00.00, where
 minutes, seconds and miliseconds are decremented.
 */
static int timeMiliSec = 0;
static int timeSec = 0;
static int timeMin = 1;
static NSTimer *timer; //Timer object that allows the time to be decremented
static NSString* timeNow; //The current time that is displayed on the label

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup countries dictionary
    continents = [[NSArray alloc] initWithObjects:@"Asia", @"Africa", @"Europe", @"Oceania", @"North_America", @"South_America", nil];
    
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    self.countriesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePath];
    
    self.countries = [[NSMutableArray alloc] initWithArray:[self.countriesDictionary allKeys]];
    
    countriesForPicker = [[NSMutableArray alloc] initWithCapacity:[self.countries count]];
    [self fillPickerArray];
    [self shuffle];
    
    [self.countryPicker selectRow:[[countriesForPicker objectAtIndex:cardNumber] integerValue] inComponent:0 animated:YES];
    
    continentPins = [[NSMutableArray alloc] initWithCapacity:[continents count]];
    
    // Sets up the gesture recognizer for each image view
    for (int i = 0; i < continents.count; i++)
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleSingleTap:)];
        UIImageView *pin = [self valueForKey:[continents objectAtIndex:i]];
        [pin addGestureRecognizer:singleTap];
    }
}

// When the user goes back to the main menu, the timer resets
- (void) viewDidDisappear:(BOOL)animated
{
    [self resetTimer];
}

// Handles a tap on the imageview
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    // If it's the first tap, then start the timer
    if (isFirstTap)
    {
        [self startTimer];
        isFirstTap = NO;
    }
    
    NSInteger mapPin = [(UIImageView *)[gestureRecognizer view] tag];
    NSString *continentTouched = [continents objectAtIndex:mapPin];
    NSString *continentTouchedCorrected = [continentTouched stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    NSString *countryPicked = [self.countries objectAtIndex:[self.countryPicker selectedRowInComponent:0]];
    
    NSString *continentOfPickedCountry = [self.countriesDictionary objectForKey:countryPicked];
    
    // If the touched continent is the same as the continent of the country the UIPickerView shows
    // Then set the pin's color to green and select another country randomly
    if ([continentTouchedCorrected isEqualToString:continentOfPickedCountry]) {
        
        continentPin = [self valueForKey:[NSString stringWithFormat:@"%@Pin", [continents objectAtIndex:mapPin]]];
        [continentPins addObject:continentPin];
        [[continentPins lastObject] setHighlighted:YES];
        
        cardNumber++;
        if (cardNumber == 40)
        {
            [self shuffle];
            totalScore = 40;
            cardNumber = 0;
        }
        [self.countryPicker selectRow:[[countriesForPicker objectAtIndex:cardNumber] integerValue] inComponent:0 animated:YES];
    }
}

// Fills the array for the UIPickerView
- (void) fillPickerArray
{
    for (int i = 0; i < [self.countries count]; i++)
    {
        [countriesForPicker insertObject:[[NSNumber alloc] initWithInt:i] atIndex:i];
    }
}

//Shuffles the array to create a random order in which the labels are displayed
- (void)shuffle
{
    
    NSUInteger count = [countriesForPicker count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        uint16_t nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [countriesForPicker exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

/*
 Call This to Start timer, will tick every 0.1 seconds.
 */
-(void) startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode: NSRunLoopCommonModes];
}

/*
 Event called every time the NSTimer ticks.
 */
- (void)timerTick:(NSTimer *)timer
{
    timeMiliSec-=100;
    if (timeMiliSec == -100)
    {
        timeMiliSec = 900;
        timeSec--;
        
        // Logic for the pin coloring. Green pins are set back to red pins every 2 seconds.
        if (timeSec % 2 == 0 && [continentPins count] != 0)
        {
            for (int i = 0; i < [continentPins count]; i++)
                [[continentPins objectAtIndex:i] setHighlighted:NO];
            
            [continentPins removeAllObjects];
        }
    }
    if (timeSec == -1)
    {
        timeSec = 59;
        timeMin--;
    }
    //Format the string 00:00.00 (mn:sc.ms)
    timeNow = [NSString stringWithFormat:@"%02d:%02d.%02d", timeMin, timeSec, timeMiliSec/10];
    //Display on your label
    self.timerLabel.text= timeNow;
    
    if (timeMiliSec == 0 && timeSec == 0 && timeMin == 0)
    {
        [timer invalidate];
        
        totalScore += cardNumber;
        [self changeSectionData:[NSString stringWithFormat:@"%d", totalScore]];
        // Alert view showing score
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"Your score: %d", totalScore]
                                                       delegate:self
                                              cancelButtonTitle:@"Take Quiz Again"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Reset the view when the Take Quiz Again button is clicked from the AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [self resetTimer];
        [self shuffle];
        
        cardNumber = 0;
        totalScore = 0;
        [self.countryPicker selectRow:[[countriesForPicker objectAtIndex:cardNumber] integerValue] inComponent:0 animated:YES];
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
    [sections setValue:imageName forKey:@"Medium Quiz"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}

/*
 Resets the timer to its initial settings.
 -Stop the timer.
 -Miliseconds, Seconds, Minutes and Hours set to 0.
 -Current time is set to 00:00:00.00
 -The timerLabel is set to the current time.
 */
- (void) resetTimer
{
    [timer invalidate];
    timeMiliSec = 0;
    timeSec = 0;
    timeMin = 1;
    timeNow = [NSString stringWithFormat:@"%02d:%02d.%02d", timeMin, timeSec, timeMiliSec];
    self.timerLabel.text = timeNow;
    isFirstTap = YES;
}
#pragma mark - UIPickerView Delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countries.count;
}

// Custom view for a picker view row
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:30];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text = [self.countries objectAtIndex:row];
    }
    return tView;
}

@end
