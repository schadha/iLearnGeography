//
//  FactsSectionViewController.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 12/13/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface FactsSectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

// Table view which is populted with all the countries
@property (strong, nonatomic) IBOutlet UITableView *countryTable;

// Web view which displays the web page associated with a country
@property (strong, nonatomic) IBOutlet UIWebView *countryWebView;

// Search bar that allows for the table view to be filtered
@property (strong, nonatomic) IBOutlet UISearchBar *countrySearchBar;

// Dictionaries representing the countries and continents
@property (strong, nonatomic) NSDictionary *countriesDictionary;
@property (strong, nonatomic) NSDictionary *regionDictionary;

// Arrays representing the continents, countryies and filtered countries for the search view controller
@property (strong, nonatomic) NSArray *regions;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSMutableArray *filteredcountries;



@end
