//
//  FactsSectionViewController.m
//  iLearnGeography
//
//  Created by Sanchit Chadha on 12/13/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import "FactsSectionViewController.h"

@interface FactsSectionViewController ()

@end

@implementation FactsSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Sets up the countries and continents dictionaries
    NSString *countriesDictionaryPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    NSString *regionsDictionaryPath = [[NSBundle mainBundle] pathForResource:@"CountryInformation" ofType:@"plist"];
    
    self.countriesDictionary = [[NSDictionary alloc] initWithContentsOfFile:countriesDictionaryPath];
    self.regionDictionary = [[NSDictionary alloc] initWithContentsOfFile:regionsDictionaryPath];
    
    self.countries = [self.countriesDictionary allKeys];
    self.regions = [[self.regionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.filteredcountries = [NSMutableArray arrayWithCapacity:[self.countries count]];
    
    // Initial web page loaded for the web view.
    [self.countryWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://en.m.wikipedia.org/w/index.php?title=Algeria"]]];
    
    //Sets up the country and search table views
    [self.countryTable setSectionHeaderHeight:35];
    [self.searchDisplayController.searchResultsTableView setSectionHeaderHeight:35];
    
    // Sets the minimum number of touches to activate the sliding view controller to 3
    // so gesture functionality in the view is not disturbed.
    self.slidingViewController.panGesture.minimumNumberOfTouches = 3;
    
    // Visiting this view changes the table view cell to a green dot
    [self changeSectionData:@"green-dot"];
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
    [sections setValue:imageName forKey:@"Facts Section"];
    [sections writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionData = sections;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource Protocol Methods

// Sets up the header for a table view section.
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    [headerView setBackgroundColor:[[UIColor alloc] initWithRed:.556862745 green:.831372549 blue:.905882353 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width - 10, 18)];
    
    label.font = [UIFont boldSystemFontOfSize:20];
    
    // Text is Search Results if the search display controller is used, else it is the continent name
    if (tableView == self.searchDisplayController.searchResultsTableView)
        label.text = @"Search Results";
    else
        label.text = [self.regions objectAtIndex:section];
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

// Each table view section corresponds to a genre. Returns the number of sections in the view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else
        return [self.regions count];
}


// Number of countries is the number of rows in the given section (continent)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // The continent corresponding to the specified section
    NSString *region = [self.regions objectAtIndex:section];
    
    // The countries corresponding to the specified continent
    NSArray *countriesForRegion = [[self.regionDictionary objectForKey:region] allKeys];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredcountries count];
    } else {
        return [countriesForRegion count];
    }
}

// Customize the appearance of the table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reference to each cell based on the on the cell identifier, countryCell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryCell"];
    
    // Configure the cell
    NSUInteger sectionNumber = [indexPath section];
    NSUInteger rowNumber = [indexPath row];
    
    NSString *region = [self.regions objectAtIndex:sectionNumber];
    NSArray *countriesForRegion = [[[self.regionDictionary objectForKey:region] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *country;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        country = [self.filteredcountries objectAtIndex:rowNumber]; // Country from the filtered array corresponding to the cell
    else
        country = [countriesForRegion objectAtIndex:rowNumber]; // Country corresponding to the cell

    // Setup the flag image for each coutnry
    CGSize itemSize = CGSizeMake(100, 80);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    NSString*imageName = [NSString stringWithFormat:@"%@-flag.png", country];
    UIImage *image = [UIImage imageNamed:imageName];
    [image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Sets the textLabel and detailTextLabel of the cell
    cell.textLabel.text = country;
    
    return cell;
}

// Tapping a row (coutnry) displays the wikipedia page associated with that country
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger sectionNumber = [indexPath section];
    NSUInteger rowNumber = [indexPath row];
    
    NSString *region = [self.regions objectAtIndex:sectionNumber];
    NSArray *countriesForRegion = [[[self.regionDictionary objectForKey:region] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    
    NSString *country;
    NSString *url;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        country = [self.filteredcountries objectAtIndex:rowNumber];
        url = [[[self.regionDictionary objectForKey:[self.countriesDictionary objectForKey:country]] objectForKey:country] objectAtIndex:1];
    }
    else
    {
        country = [countriesForRegion objectAtIndex:rowNumber];
        url = [[[self.regionDictionary objectForKey:region] objectForKey:country] objectAtIndex:1];
    }
    
    // Loads the url for that country on the webview
    [self.countryWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    // Close the search view controller when a row is tapped in the search table view.
    if (tableView == self.searchDisplayController.searchResultsTableView)
        [self.searchDisplayController setActive:NO animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Content Filtering
// Filters the content of an array based on the search string given
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredcountries removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.filteredcountries = [NSMutableArray arrayWithArray:[self.countries filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.countryWebView loadHTMLString:errorString baseURL:nil];
}
@end
