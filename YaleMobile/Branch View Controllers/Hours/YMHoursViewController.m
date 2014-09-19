//
//  YMHoursViewController.m
//  YaleMobile
//
//  Created by Danqing on 1/30/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMHoursViewController.h"
#import "YMHoursListViewController.h"
#import "YMHoursDetailViewController.h"
#import "YMSimpleCell.h"
#import "YMGlobalHelper.h"
#import "YMTheme.h"
#import "YMServerCommunicator.h"

#import "YMTheme.h"

@interface YMHoursViewController ()

@end

@implementation YMHoursViewController

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
  [YMGlobalHelper addMenuButtonToController:self];
  self.types = @[@"Libraries", @"Dining - Retail Facilities", @"Payne Whitney Gym", @"Yale Transit"];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
  self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [YMServerCommunicator cancelAllHTTPRequests];
  [YMGlobalHelper setupSlidingViewControllerForController:self];
  if (self.selectedIndexPath) {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = nil;
  }
  
  [self.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
  self.navigationController.navigationBar.alpha = 1.0;
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

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  UIView *cell = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
  if (fabsf(translation.x) > fabsf(translation.y)) return YES;
  return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Hours Detail Segue"]) {
    YMHoursDetailViewController *hdvc = (YMHoursDetailViewController *)segue.destinationViewController;
    hdvc.data = self.detailData;
    hdvc.title = self.detailTitle;
  } else {
    YMHoursListViewController *hlvc = (YMHoursListViewController *)segue.destinationViewController;
    hlvc.data = self.detailData;
    hlvc.title = self.detailTitle;
  }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.types.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSimpleCell *cell;
  
  if (indexPath.row == 0) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Cell 0"];
  else if (indexPath.row == 1) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Cell 1"];
  else if (indexPath.row == self.types.count + 1) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Footer"];
  else cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Cell 2"];
  
  if (indexPath.row == 0) {
    cell.name1.text = @"Select a Category";
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
  } else if (indexPath.row == self.types.count + 1) {
    NSString *text = @"Library hours are synced with Yale Library website but may not reflect special conditions. Dining and gym hours only refer to regular schedule. Please double check during holidays and special events.";
    cell.name1.text = text;
    cell.name1.numberOfLines = 0;
    /* deprecated
     CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:CGSizeMake(280, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] andConstraintSize:CGSizeMake(280, 5000)];
    CGRect frame = cell.name1.frame;
    frame.size.height = textSize.height;
    cell.userInteractionEnabled = NO;
    cell.name1.frame = frame;
  } else {
    cell.name1.text = [self.types objectAtIndex:indexPath.row - 1];
    cell.name1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    if (indexPath.row == 1) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
    } else if (indexPath.row == self.types.count) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
      cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
  }
  
  cell.name1.textColor = [YMTheme gray];
  cell.backgroundView.alpha = 0.6;
  
//  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
//                                                forCell:cell];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
      return [YMTheme groupedTableTopLabelCellHeight];
  else if (indexPath.row == 1 || indexPath.row == self.types.count)
      return [YMTheme groupedTableFirstOrLastCellHeight];
  else if (indexPath.row == self.types.count + 1)
    return 100;
  else
    return [YMTheme groupedTableMiddleCellHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedIndexPath = indexPath;
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
    NSString *path;
    if (indexPath.row == 2) {
      path = [[NSBundle mainBundle] pathForResource:@"Retail" ofType:@"plist"];
      self.detailTitle = @"Retail Facilities";
    } else if (indexPath.row == 3) {
      path = [[NSBundle mainBundle] pathForResource:@"PWG" ofType:@"plist"];
      self.detailTitle = @"PWG";
    } else {
      path = [[NSBundle mainBundle] pathForResource:@"Shuttle" ofType:@"plist"];
      self.detailTitle = @"Yale Transit";
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.detailData = dict;
    [self performSegueWithIdentifier:@"Hours Detail Segue" sender:self];
  } else {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Libraries" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.detailData = dict;
    self.detailTitle = @"Libraries";
    [self performSegueWithIdentifier:@"Hours List Segue" sender:self];
  }
}

@end
