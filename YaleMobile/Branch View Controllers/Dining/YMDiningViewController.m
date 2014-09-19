//
//  YMDiningViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMDiningViewController.h"
#import "YMDiningDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMDiningCell.h"
#import "YMServerCommunicator.h"

#import "YMTheme.h"

#import "UIImage+ImageWithColor.h"

@interface YMDiningViewController ()

@end

@implementation YMDiningViewController

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
  [YMServerCommunicator cancelAllHTTPRequests];
  
  [super viewDidLoad];
  [YMGlobalHelper addMenuButtonToController:self];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Dining" ofType:@"plist"];
  self.locations = [[NSDictionary alloc] initWithContentsOfFile:path];
  self.sortedKeys = [[self.locations allKeys] sortedArrayUsingSelector:@selector(compare:)];
  
  [YMServerCommunicator getAllDiningStatusForController:self usingBlock:^(NSArray *array) {
    self.data = array;
    [YMServerCommunicator getDiningSpecialInfoForController:self usingBlock:^(NSArray *array) {
      self.special = array;
      [self.tableView reloadData];
    }];
  }];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorInset = UIEdgeInsetsZero;
  self.tableView.separatorColor = [YMTheme separatorGray];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [YMGlobalHelper setupSlidingViewControllerForController:self];
  if (self.selectedIndexPath) {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = nil;
  }
  
  [self.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
  self.navigationController.navigationBar.alpha = 1.0;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  UIView *cell = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
  if (fabsf(translation.x) > fabsf(translation.y)) return YES;
  return NO;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  YMDiningDetailViewController *ddvc = (YMDiningDetailViewController *)segue.destinationViewController;
  NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[self.locations objectForKey:[self.sortedKeys objectAtIndex:self.selectedIndexPath.row]]];
  ddvc.titleText = [info objectForKey:@"Name"];
  ddvc.abbr = [info objectForKey:@"Abbreviation"];
  ddvc.address = [info objectForKey:@"Location"];
  NSInteger i;
  for (NSArray *a in self.data) {
    if ([[info objectForKey:@"Name"] isEqualToString:[a objectAtIndex:2]]) {
      i = [[a objectAtIndex:0] integerValue];
      break;
    }
  }
  ddvc.locationID = i;
  ddvc.hour = [self parseHours:[info objectForKey:@"Hours"]];
  ddvc.special = (self.special.count) ? [self.special objectAtIndex:self.selectedIndexPath.row * 3 + 2] : @"Information not available";
}

- (NSString *)parseHours:(NSArray *)array
{
  NSMutableArray *components = [[NSMutableArray alloc] init];
  for (NSDictionary *entry in array) {
    [components addObject:[NSString stringWithFormat:@"%@\n\t\t• ", [[entry allKeys] objectAtIndex:0]]];
    [components addObject:[NSString stringWithFormat:@"%@\n", [[[entry allValues] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t• "]]];
  }
  return [components componentsJoinedByString:@""];
}

- (NSString *)crowdedness:(NSInteger)degree
{
  if (degree == 0) return @"Closed";
  if (degree == 1 || degree == 2) return @"Very Empty";
  if (degree == 3 || degree == 4) return @"Mostly Empty";
  if (degree == 5 || degree == 6) return @"Moderate";
  if (degree == 7 || degree == 8) return @"Mostly Full";
  else return @"Extremely Full";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.sortedKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMDiningCell *cell = (YMDiningCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Cell"];
  NSDictionary *info = [[NSDictionary alloc] initWithDictionary:[self.locations objectForKey:[self.sortedKeys objectAtIndex:indexPath.row]]];
  cell.name1.text = [info objectForKey:@"Name"];
  cell.location1.text = [info objectForKey:@"Location"];
  
  NSArray *array;
  
  for (NSArray *a in self.data) {
    if ([[info objectForKey:@"Name"] isEqualToString:[a objectAtIndex:2]]) {
      array = a;
      break;
    }
  }
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor] forCell:cell];
  
  if (self.special.count) {
    cell.special1.text = [self.special objectAtIndex:indexPath.row * 3 + 1];
    if ([[self.special objectAtIndex:indexPath.row * 3] integerValue] == 0) {
      cell.special1.textColor = [YMTheme YMDiningBlue];
      cell.special1.highlightedTextColor = [YMTheme YMDiningBlue];
    } else if ([[self.special objectAtIndex:indexPath.row * 3] integerValue] == 1) {
      cell.special1.textColor = [YMTheme YMDiningRed];
      cell.special1.highlightedTextColor = [YMTheme YMDiningRed];
    } else {
      cell.special1.textColor = [YMTheme YMDiningGreen];
      cell.special1.highlightedTextColor = [YMTheme YMDiningGreen];
    }
  } else {
    cell.special1.text = @"Status Unavailable";
    cell.special1.textColor = [UIColor darkGrayColor];
    cell.special1.highlightedTextColor = [UIColor darkGrayColor];
  }
  
  cell.crowdLabel1.text = [self crowdedness:[[array objectAtIndex:4] integerValue]];
  cell.crowdedness1.image = [UIImage imageNamed:[NSString stringWithFormat:@"dots%ld.png", (long)([[array objectAtIndex:4] integerValue] + 1) / 2]];
  if ([[array objectAtIndex:6] integerValue]) {
    cell.crowdLabel1.text = @"Closed";
    cell.crowdedness1.image = [UIImage imageNamed:@"dots0.png"];
  }
  
  if ([[self.special objectAtIndex:indexPath.row * 3] integerValue] != 0)
    cell.crowdLabel1.text = @"Special";
  
  cell.name1.textColor       = [YMTheme gray];
  cell.location1.textColor   = [YMTheme lightGray];
  cell.special1.textColor    = [YMTheme diningSpecialTextColor];
  cell.crowdLabel1.textColor = [YMTheme lightGray];
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
                                                forCell:cell];
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedIndexPath = indexPath;
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self performSegueWithIdentifier:@"Dining Segue" sender:self];
}

@end
