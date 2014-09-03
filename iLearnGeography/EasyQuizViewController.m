//
//  EasyQuizViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/24/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "EasyQuizViewController.h"

@interface EasyQuizViewController ()

@end

@implementation EasyQuizViewController

static int cardNumber = 0;
static NSArray *continents;

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
    
    // Setup the continent arrays and dictionary
    continents = [[NSArray alloc] initWithObjects:@"Asia", @"Africa", @"Europe", @"Oceania", @"North America", @"South America", nil];
    
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    self.countriesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePath];
    
    self.countries = [[NSMutableArray alloc] initWithArray:[self.countriesDictionary allKeys]];
    
    // Shuffle the countries
    [self shuffle];
    
    // Set up the view
    cardNumber = 0;
    NSString *countryName = [self.countries objectAtIndex:cardNumber];
    [self.countryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",countryName]]];
    self.countryName.text = countryName;
    
    [self resetTimer];
    
}

// When the user goes back to the main menu, the timer resets
- (void) viewDidDisappear:(BOOL)animated
{
    [self resetTimer];
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

#pragma mark - UIPickerView Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return continents.count;
}

// Custom view for the UIPickerView rows
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:30];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text = [continents objectAtIndex:row];
    }
    return tView;
}

// Checks to see if the continent selected matches the continent of the country shown
// If so, then the next country is shown
- (IBAction)submitAnswer:(UIButton *)sender
{
    
    NSString *continentSelected = [continents objectAtIndex:[self.continentPicker selectedRowInComponent:0]];
    NSString *countryDisplayed = [self.countriesDictionary objectForKey:[self.countries objectAtIndex:cardNumber]];
    
    if ([continentSelected isEqualToString:countryDisplayed]) {
        if (cardNumber == 0)
        {
            [self startTimer];
        }
        cardNumber++;
        NSString *countryName = [self.countries objectAtIndex:cardNumber];
        [self.countryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",countryName]]];
        self.countryName.text = countryName;
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
        
        [self changeSectionData:[NSString stringWithFormat:@"%d", cardNumber]];
        
        // Alert view showing the score
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:[NSString stringWithFormat:@"Your score: %d", cardNumber]
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
        NSString *countryName = [self.countries objectAtIndex:cardNumber];
        [self.countryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",countryName]]];
        self.countryName.text = countryName;
        
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
    [sections setValue:imageName forKey:@"Easy Quiz"];
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
}

@end
