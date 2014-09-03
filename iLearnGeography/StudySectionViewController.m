//
//  StudySectionViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/21/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "StudySectionViewController.h"

@interface StudySectionViewController ()

@end

@implementation StudySectionViewController

static int cardNumber = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Stup the continent arrays and dictionary
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    self.countriesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePath];
    
    self.countries = [[NSMutableArray alloc] initWithArray:[self.countriesDictionary allKeys]];
    
    // Shuffle the countries
    [self shuffle];
    
    // Setup the view and add a gesture recognizer to the country image
    NSString *countryName = [self.countries objectAtIndex:cardNumber];
    [self.countryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",countryName]]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self.countryImage addGestureRecognizer:singleTap];
}

// Handles a single tap on the image. When tapped, the country and continent names are revealed.
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    [self.countryName setHidden:NO];
    [self.continentName setHidden:NO];
    
    NSString *countrySelected = [self.countries objectAtIndex:cardNumber];
    NSString *continentOfSelectedCountry = [self.countriesDictionary objectForKey:countrySelected];
    
    self.countryName.text = countrySelected;
    self.continentName.text = continentOfSelectedCountry;
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
    [sections setValue:imageName forKey:@"Study Section"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}

// Handler for the random button. Shows the next card from the countries array.
// If it's the last card, then set the Study Section image on the menu view to a green dot.
- (IBAction)randomFlashCard:(UIButton *)sender
{
    if (cardNumber == 39)
    {
        [self changeSectionData:@"green-dot"];
        [self shuffle];
        cardNumber = -1;
    }
    [self.countryName setHidden:YES];
    [self.continentName setHidden:YES];
    
    self.cardNumber.text = [NSString stringWithFormat:@"%i/%lu",++cardNumber + 1,(unsigned long)[self.countries count]];
    NSString *countryName = [self.countries objectAtIndex:cardNumber];
    [self.countryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",countryName]]];
}

@end
