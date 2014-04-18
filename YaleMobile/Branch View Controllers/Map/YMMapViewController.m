//
//  YMMapViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#define METERS_PER_MILE 1609

#import <CoreData/CoreData.h>
#import "YMMapViewController.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMMapViewAnnotation.h"
#import "YMGlobalHelper.h"
#import "YMTwoSubtitlesCell.h"
#import "Place.h"
#import "Abbreviation.h"
#import "YMDatabaseHelper.h"
#import "UIColor+YaleMobile.h"
#import "YMServerCommunicator.h"

@interface YMMapViewController ()

@end

@implementation YMMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 700)];
    self.searchOverlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapoverlay.png"]];
    
    [YMGlobalHelper addMenuButtonToController:self];
    
    UIButton *locate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 23)];
    [locate setBackgroundImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [locate setBackgroundImage:[UIImage imageNamed:@"locate_highlight.png"] forState:UIControlStateHighlighted];
    [locate setBackgroundImage:[UIImage imageNamed:@"locate_highlight.png"] forState:UIControlStateSelected];
    [locate addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:locate]];
    self.locate = locate;
    self.locating = 0;
    self.zoomForAnnotation = NO;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)viewWillAppear:(BOOL)animated
{
    [YMServerCommunicator cancelAllHTTPRequests];

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[YMMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.3123;
    zoomLocation.longitude = -72.9281;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, span);
    [self.mapView setRegion:region animated:YES];
        
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (!(self.database = [YMDatabaseHelper getManagedDocument])) {
        [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {
            self.database = document;
            [YMDatabaseHelper setManagedDocumentTo:document];
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)locate:(id)sender
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied" message:@"Location service is turned off for YaleMobile. If you would like to grant YaleMobile access, please go to Settings - Location Services." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.locating) {
        self.locating = 0;
        self.mapView.showsUserLocation = NO;
        [self.locate setSelected:NO];
    } else {
        self.locating = 1;
        self.mapView.showsUserLocation = YES;
        [self.locate setSelected:YES];
    }
}

- (void)updateMapView {    
    if (self.mapView.annotations)
        [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.locating != 0)
        self.mapView.showsUserLocation = YES;
    
    if (self.annotation) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.annotation.coordinate, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        self.zoomForAnnotation = YES;
        [self.mapView setRegion:adjustedRegion animated:YES];
    }
}

# pragma mark - mapview methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.annotation && self.zoomForAnnotation) {
        [self.mapView addAnnotation:self.annotation];
        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
    self.zoomForAnnotation = NO;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.locating == 1 && userLocation.location.coordinate.latitude != 0) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        self.locating = 2;
    }
}

- (void)zoomMapAndCenterAtLatitude:(double)latitude andLongitude:(double)longitude {
    MKCoordinateRegion region;
    region.center.latitude  = latitude;
    region.center.longitude = longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = .020;
    span.longitudeDelta = .020;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

# pragma mark - search bar methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (searchBar.text.length) {
        self.searchResults = [self searchForString:searchBar.text];
        [self.tableView reloadData];
        self.tableView.alpha = 0;
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0.1 options:nil animations:^{
            self.tableView.alpha = 1;
        } completion:nil];
    } else
        [self showOverlay];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self hideKeyboard];
    self.tableView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self hideKeyboard];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(hideTableView) userInfo:nil repeats:NO];
        [self showOverlay];
    } else {
        [self hideOverlay];
        self.searchResults = [self searchForString:searchText];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }
}

- (void)hideTableView
{
    self.tableView.hidden = YES;
}

- (void)hideKeyboard
{
    [self hideOverlay];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)showOverlay
{
    self.searchOverlay.alpha = 0;
    [self.view addSubview:self.searchOverlay];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 1;
    [UIView commitAnimations];
}

- (void)hideOverlay
{
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 0;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(removeOverlay:) userInfo:nil repeats:NO];
}

- (void)removeOverlay:(NSTimer *)timer
{
    [self.searchOverlay removeFromSuperview];
}

- (NSArray *)searchForString:(NSString *)searchString
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *filterPredicate = nil;
    NSPredicate *filterPredicate2 = nil;
    
    if (searchString.length) {
        filterPredicate = [NSPredicate predicateWithFormat:@"ANY abbrs.name =[cd] %@ OR address =[cd] %@ OR name =[cd] %@", searchString, searchString, searchString];
        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"abbrs.name CONTAINS[cd] %@ OR address CONTAINS[cd] %@ OR name CONTAINS[cd] %@", searchString, searchString, searchString];
        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"NONE abbrs.name =[cd] %@", searchString];  // this doesn't work if there are multiple abbrs.
        NSArray *predicateArray = [[NSArray alloc] initWithObjects:p1, p2, nil];
        filterPredicate2 = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    [request setPredicate:filterPredicate];
    [request setSortDescriptors:sortDescriptors];
    [request2 setPredicate:filterPredicate2];
    [request2 setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *match1 = [self.database.managedObjectContext executeFetchRequest:request error:&error];
    NSArray *match2 = [self.database.managedObjectContext executeFetchRequest:request2 error:&error];
    NSMutableArray *mutableMatch2 = [match2 mutableCopy];
    
    for (Place *p in match2) {
        for (Place *q in match1) {
            if (p == q) [mutableMatch2 removeObject:p];
        }
    }

    NSArray *resultArray = [[NSArray alloc] initWithObjects:match1, mutableMatch2, nil];
    
    return resultArray;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    return pinView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchResults) return 0;
    if (section == 0) return ((NSArray *)[self.searchResults objectAtIndex:0]).count;
    else return ((NSArray *)[self.searchResults objectAtIndex:1]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMTwoSubtitlesCell *cell = ((indexPath.section == 0 || ((NSArray *)[self.searchResults objectAtIndex:0]).count == 0) && indexPath.row == 0) ? (YMTwoSubtitlesCell *)[tableView dequeueReusableCellWithIdentifier:@"Map Top Cell"] : (YMTwoSubtitlesCell *)[tableView dequeueReusableCellWithIdentifier:@"Map Cell"];
    
    Place *place;
    if (indexPath.section == 0) {
        place = [((NSArray *)[self.searchResults objectAtIndex:0]) objectAtIndex:indexPath.row];
        cell.name.textColor = [UIColor YMBluebookOrange];
    } else {
        place = [((NSArray *)[self.searchResults objectAtIndex:1]) objectAtIndex:indexPath.row];
        cell.name.textColor = [UIColor YMTeal];
    }
    
    cell.name.text = place.name;
    cell.sub1.text = [NSString stringWithFormat:@"Address: %@", place.address];
    
    NSString *abbrs;
    for (Abbreviation *abbr in place.abbrs) {
        if (abbrs.length == 0) abbrs = abbr.name;
        else abbrs = [abbrs stringByAppendingFormat:@", %@", abbr.name];
    }
    cell.sub2.text = [NSString stringWithFormat:@"Known as: %@", abbrs];
    
    if (((NSArray *)[self.searchResults objectAtIndex:0]).count + ((NSArray *)[self.searchResults objectAtIndex:1]).count == 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    } else if ((indexPath.section == 0 || ((NSArray *)[self.searchResults objectAtIndex:0]).count == 0) && indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
    } else if ((indexPath.section == 1 && indexPath.row == ((NSArray *)[self.searchResults objectAtIndex:1]).count - 1) || (indexPath.section == 0 && indexPath.row == ((NSArray *)[self.searchResults objectAtIndex:0]).count - 1 && ((NSArray *)[self.searchResults objectAtIndex:1]).count == 0)) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    cell.backgroundView.alpha = 0.9;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (((NSArray *)[self.searchResults objectAtIndex:0]).count + ((NSArray *)[self.searchResults objectAtIndex:1]).count == 1) {
        return 90;
    } else if (((indexPath.section == 0 || ((NSArray *)[self.searchResults objectAtIndex:0]).count == 0) && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == ((NSArray *)[self.searchResults objectAtIndex:1]).count - 1) || (indexPath.section == 0 && indexPath.row == ((NSArray *)[self.searchResults objectAtIndex:0]).count - 1 && ((NSArray *)[self.searchResults objectAtIndex:1]).count == 0)) {
        return 80;
    } else {
        return 72;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideTableView];
    [self hideKeyboard];
    self.annotation = [[YMMapViewAnnotation alloc] initWithPlace:[[self.searchResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [self updateMapView];
}

@end
