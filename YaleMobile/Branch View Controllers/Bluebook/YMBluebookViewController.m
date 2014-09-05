//
//  YMBluebookViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMBluebookViewController.h"
#import "YMBluebookFilterViewController.h"
#import "YMBluebookSubjectViewController.h"
#import "YMGlobalHelper.h"
#import "YMSimpleCell.h"
#import "YMServerCommunicator.h"
#import "YMTheme.h"
#import "AFHTTPRequestOperation.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Course+OCI.h"
#import "UIView+AutoLayout.h"
#import "NSString+URLEncode.h"
#import "YMAppDelegate.h"
#import <SWRevealViewController/SWRevealViewController.h>

#import <PureLayout/PureLayout.h>

static NSString* filterFormatString = @"&ProgramSubject=%@&InstructorName=%@&ExactWordPhrase=%@&CourseNumber=%@";
static NSString* resultWindowUrl    = @"http://students.yale.edu/oci/resultWindow.jsp";
static NSString* resultListUrl      = @"http://students.yale.edu/oci/resultList.jsp";

@interface YMBluebookViewController ()

- (void)updateTable;

@end

@implementation YMBluebookViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.sectionIndexColor = [[YMTheme blue] colorWithAlphaComponent:0.7];

  [self updateTable];
  [YMGlobalHelper addMenuButtonToController:self];
  
  UIButton *settings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
  [settings setBackgroundImage:[UIImage imageNamed:@"button_navbar_settings.png"] forState:UIControlStateNormal];
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:settings]];
  [settings addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Bluebook" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
  self.courses = dict;
  self.keys = [[self.courses allKeys] sortedArrayUsingSelector:@selector(compare:)];
  self.instructorName = @""; self.courseNumber = @""; self.exactPhrase = @"";
  
  CGRect rect = self.searchBar1.frame;
  UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height - 1, rect.size.width, 1)];
  lineView.backgroundColor = [UIColor lightGrayColor];
  [self.searchBar1 addSubview:lineView];
  
  if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
  }
  
  self.tableView.separatorInset = UIEdgeInsetsZero;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [YMTheme lightGrey];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [YMServerCommunicator cancelAllHTTPRequests];
  [YMGlobalHelper setupSlidingViewControllerForController:self];
  YMBluebookFilterViewController *filterRoot = [self.storyboard instantiateViewControllerWithIdentifier:@"Bluebook Filter Root"];
  self.revealViewController.rightViewController = filterRoot;
  if (self.selectedIndexPath) {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = nil;
  }
  [self removeDisplayOverlay];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self removeDisplayOverlay];
  self.revealViewController.rightViewController = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  UIView *cell = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
  if (fabsf(translation.x) > fabsf(translation.y)) return YES;
  return NO;
}

- (void)updateTable
{
  // first check all existing cells and apply filter.
  
  // then check all new cells and apply filter.
}

- (void)menu:(id)sender
{
  [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)settings:(id)sender
{
  self.revealViewController.rearViewRevealWidth = 280.0f;
  [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)showAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)prepareSubjectViewController:(YMBluebookSubjectViewController *)svc
{
  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  NSDictionary *dict = [self.courses objectForKey:[self.keys objectAtIndex:indexPath.section]];
  NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSString *subject = [[dict objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"Value"];
  
  svc.title = ([subject isEqualToString:@"ALL"]) ? @"Search Results" : subject;
  
  NSString *filters = [YMGlobalHelper buildBluebookFilters];
  filters = [filters stringByAppendingFormat:filterFormatString, [subject stringByReplacingOccurrencesOfString:@"&" withString:@"%26"], [self.instructorName urlEncode], [self.exactPhrase urlEncode], [self.courseNumber urlEncode]];
  self.instructorName = @""; self.courseNumber = @""; self.exactPhrase = @"";
  
  __block AFHTTPRequestOperationManager *client = [YMServerCommunicator getOperationManager];
  __block AFHTTPRequestSerializer *serializer = [YMServerCommunicator getRequestSerializer];
  NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:[resultWindowUrl stringByAppendingString:filters] parameters:nil error:nil];
  
  DLog(@"%@", [resultWindowUrl stringByAppendingString:filters]);
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSMutableURLRequest *request2 = [serializer requestWithMethod:@"GET" URLString:[resultListUrl stringByAppendingString:filters] parameters:nil error:nil];
    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
    
    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSString *responseString = operation.responseString;
      
      responseString = [responseString stringByReplacingOccurrencesOfString:@"  <br>" withString:@", "];
      responseString = [responseString stringByReplacingOccurrencesOfString:@" <br>" withString:@", "];
      responseString = [responseString stringByReplacingOccurrencesOfString:@"<br>" withString:@", "];
      responseString = [responseString stringByReplacingOccurrencesOfString:@"<td valign=\"TOP\" NOWRAP class=\"S\"><a alt=\"Click for Session Info\"" withString:@"<td>"];
      
      svc.raw = responseString;
      [svc useDocument];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [YMGlobalHelper hideNotificationView];
      svc.tableView.scrollEnabled = YES;
      if (![YMServerCommunicator isCanceled]) {
        DLog(@"%@", operation.responseString);
        if ([operation.responseString rangeOfString:@"No courses match selection."].location != NSNotFound) {
          [self showAlertViewWithTitle:@"YaleMobile Bluebook"
                            andMessage:@"No courses match your selection. Please try again."];
          return;
        }
        
        [self showAlertViewWithTitle:@"Connection Error"
                          andMessage:@"YaleMobile is unable to reach Course Selection server. Please check your Internet connection and try again."];
      }
    }];
    [YMServerCommunicator resetCanceled];
    [[client operationQueue] addOperation:operation2];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [YMGlobalHelper hideNotificationView];
    svc.tableView.scrollEnabled = YES;
    if (![YMServerCommunicator isCanceled]) {
      [self showAlertViewWithTitle:@"Connection Error"
                        andMessage:@"YaleMobile is unable to reach Course Selection server. Please check your Internet connection and try again."];
    }
  }];
  
  [YMServerCommunicator resetCanceled];
  [[client operationQueue] addOperation:operation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#warning TODO(hc) add segue identifier test here
  YMBluebookSubjectViewController *svc = (YMBluebookSubjectViewController *)segue.destinationViewController;
  
  [self prepareSubjectViewController:svc];
  
  [YMGlobalHelper showNotificationInViewController:self.navigationController
                                           message:@"Loading..."
                                         tintColor:[YMTheme notificationTintColor]];

  svc.tableView.scrollEnabled = NO;

}


- (void)removeDisplayOverlay
{
  DLog(@"disable overlay: %@", self.disableViewOverlay);
  [self.disableViewOverlay removeFromSuperview];
  self.disableViewOverlay = nil;
}

- (void)hideKeyboard
{
  self.searchDisplayController.active = NO;
  [self removeDisplayOverlay];
}

#pragma mark - Search Bar & Display delegate methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
  controller.searchBar.showsScopeBar = YES;
  controller.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Course No.", @"Instructor", @"Exact Phrase",nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
  self.searchDisplayController.searchResultsTableView.hidden = YES;
  if (!self.disableViewOverlay) {
    self.disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f,88.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor = [UIColor blackColor];
    self.disableViewOverlay.alpha = 0.8;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.disableViewOverlay addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:self.disableViewOverlay];
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  NSString *searchString = searchBar.text;
  self.searchDisplayController.active = NO;
  if (searchBar.selectedScopeButtonIndex == 0) self.courseNumber = searchString;
  else if (searchBar.selectedScopeButtonIndex == 1) self.instructorName = searchString;
  else self.exactPhrase = searchString;
  [self performSegueWithIdentifier:@"Bluebook First Segue" sender:searchBar];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
  [self removeDisplayOverlay];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[self.courses objectForKey:[self.keys objectAtIndex:section]]];
  return dict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSimpleCell *cell = (YMSimpleCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Bluebook First Cell"];
  NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[self.courses objectForKey:[self.keys objectAtIndex:indexPath.section]]];
  NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
  
  cell.name1.textColor = [YMTheme grey];
  
  cell.name1.text = [((NSDictionary *)[dict objectForKey:[keys objectAtIndex:indexPath.row]]) objectForKey:@"Name"];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 26;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 26.0)];
	
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  
  headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor grayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.frame = CGRectMake(17.0, 1.0, 300.0, 22.0);
  
  headerLabel.shadowColor = [UIColor whiteColor];
  headerLabel.shadowOffset = CGSizeMake(0, 1);
  
  headerLabel.text = [[[self.courses allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section];
	
  [headerView addSubview:headerLabel];
  
	return headerView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  NSArray *array = [[NSArray alloc] initWithObjects:UITableViewIndexSearch, nil];
  array = [array arrayByAddingObjectsFromArray:self.keys];
  return array;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  if([title isEqualToString:UITableViewIndexSearch]){
    [self.tableView setContentOffset:CGPointZero animated:NO];
    return -1;
  } else {
    return index - 1;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedIndexPath = indexPath;
  [self performSegueWithIdentifier:@"Bluebook First Segue" sender:self];
}

@end
