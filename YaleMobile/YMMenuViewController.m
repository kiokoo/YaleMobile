//
//  YMMenuViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMenuViewController.h"
#import "YMMenuCell.h"
#import "YMTheme.h"

@interface YMMenuViewController ()

@property (nonatomic, strong) NSArray *iconNames;

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
  self.items = @[@"Home", @"Bluebook", @"Dining", @"Campus Map", @"Shuttle", @"People Directory", @"Laundry", @"Facility Hours", @"Calendar", @"Phonebook", @"Settings"];
  self.iconNames = @[@"home", @"bluebook", @"dining", @"map", @"shuttle", @"people", @"laundry", @"hours", @"calendar", @"phonebook", @"settings"];
  UIView *placeHolder = [UIView new];
  CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  placeHolder.frame = CGRectMake(0, 0, self.tableView.frame.size.width, statusHeight);
  placeHolder.backgroundColor = [UIColor clearColor];
  
  self.tableView.tableHeaderView = placeHolder;
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu.png"]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMMenuCell *cell = (YMMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"Menu Cell"];
  cell.name1.textColor = [YMTheme white];
  cell.name1.text = [self.items objectAtIndex:indexPath.row];
  NSString *imageName = [NSString stringWithFormat:@"icon_sidebar_%@", [(NSString *)self.iconNames[indexPath.row] lowercaseString]];
  UIImage *icon = [UIImage imageNamed:imageName];
  cell.icon1.image = icon ? icon : [UIImage imageNamed:[NSString stringWithFormat:@"menu%ld.png", (long)indexPath.row]];
  
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
  [UIView animateWithDuration:0.2 animations:^{
    oldTopViewController.view.layer.transform = CATransform3DTranslate(oldTopViewController.view.layer.transform, dX, 0, 0);
  } completion:^(BOOL finished) {
    self.slidingViewController.topViewController = newTopViewController;
    [self.slidingViewController resetTopViewAnimated:YES];
  }];
}

@end
