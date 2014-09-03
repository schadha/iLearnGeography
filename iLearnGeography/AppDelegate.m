//
//  AppDelegate.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 11/12/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /************************************
     All application-specific and user data files must be written to the Documents directory. Nothing can be written
     into application's main bundle because it is locked for writing after your app is published. The contents of the
     Documents directory are backed up by iTunes during backup of an iOS device. Therefore, the user can recover the
     data written by your app from an earlier device backup.
     
     The Documents directory path on an iOS device is different from the one used for iOS Simulator.
     
     To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
     However, this function was designed originally for Mac OS X, where multiple such directories could exist.
     Therefore, it returns an array of paths rather than a single path.
     For iOS, the resulting array's objectAtIndex:0 is the path to the Documents directory.
     ************************************/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    //File paths in documents director of both MyFavoriteMovies and MyFavoriteTheaters plist files.
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    
    // Instantiate modifiable dictionaries and initialize them with the content of the plist files
    NSMutableDictionary *sectionData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!sectionData) {
        /*
         In this case, the Sections.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example favorite movies.
         
         Get the file path to the MyFavoriteMovies.plist file in application's main bundle.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"Sections" ofType:@"plist"];
        
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        sectionData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    
    // Assign the global variable dicationaries their respective initialized dictionaries from plist files.
    self.sectionData = sectionData;
    [self.sectionData writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    return YES;
}


// Write the favoriteMovies dictionary data structure to hard disk before the app becomes inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Sections.plist"];
    
    [self.sectionData writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    /*
     The flag "atomically" specifies whether the file should be written atomically or not.
     
     If flag is YES, the favoriteMovies/favoriteTheaters dictionary is written to an auxiliary file, and then the auxiliary file is
     renamed to path plistFilePathInDocumentsDirectory
     
     If flag is NO, the favoriteMovies/favoriteTheaters dictionary is written directly to path plistFilePathInDocumentsDirectory.
     
     The YES option guarantees that the path will not be corrupted even if the system crashes during writing.
     */
}

@end
