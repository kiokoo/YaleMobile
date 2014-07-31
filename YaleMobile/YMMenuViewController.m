//
//  YMMenuViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMenuViewController.h"
#import "YMMenuCell.h"

@interface YMMenuViewController ()

@end

@implementation YMMenuViewController

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
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg_table.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
  self.items = @[@"Home", @"Bluebook", @"Dining", @"Campus Map", @"Shuttle", @"People Directory", @"Laundry", @"Facility Hours", @"Calendar", @"Department Phonebook", @"Jump Station", @"Settings"];
  
  UIView *placeHolder = [UIView new];
  CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  placeHolder.frame = CGRectMake(0, 0, self.tableView.frame.size.width, statusHeight);
  placeHolder.backgroundColor = [UIColor clearColor];
  
  self.tableView.tableHeaderView = placeHolder;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMMenuCell *cell = (YMMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"Menu Cell"];
  cell.name1.text = [self.items objectAtIndex:indexPath.row];
  cell.icon1.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu%ld.png", (long)indexPath.row]];
  
  cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
  cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
  
  cell.name1.shadowColor = [UIColor blackColor];
  cell.name1.shadowOffset = CGSizeMake(0, 1);
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [[self.items objectAtIndex:indexPath.row] stringByAppendingString:@" Root"];
  
  UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
  DLog(@"New VC: %@", newTopViewController);
  /*
   [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
   CGRect frame = self.slidingViewController.topViewController.view.frame;
   self.slidingViewController.topViewController = newTopViewController;
   self.slidingViewController.topViewController.view.frame = frame;
   [self.slidingViewController resetTopView];
   }];
   */
  /*
  [self.slidingViewController anchorTopViewToRightAnimated:YES onComplete:^{
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = newTopViewController;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopViewAnimated:YES];
  }];
   */
  UIViewController *oldTopViewController = self.slidingViewController.topViewController;
  CGFloat dX = self.view.frame.size.width - self.slidingViewController.anchorRightRevealAmount;
  [UIView animateWithDuration:0.1 animations:^{
    oldTopViewController.view.layer.transform = CATransform3DTranslate(oldTopViewController.view.layer.transform, dX, 0, 0);
  } completion:^(BOOL finished) {
    self.slidingViewController.topViewController = newTopViewController;
    [self.slidingViewController resetTopViewAnimated:YES];
  }];
}

@end
