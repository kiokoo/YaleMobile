//
//  YMShuttleSelectionViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMShuttleSelectionViewController.h"
#import "YMShuttleSelectionCell.h"
#import "YMGlobalHelper.h"
#import "YMDatabaseHelper.h"
#import "YMRoundView.h"
#import "Route.h"
#import <PureLayout/PureLayout.h>

#import "YMTheme.h"

@interface YMShuttleSelectionViewController ()

@end

@implementation YMShuttleSelectionViewController

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
    
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
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
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0)
    return self.routes.count;
  else
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    YMShuttleSelectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Shuttle Selection Cell"];
  
    Route *route = [self.routes objectAtIndex:indexPath.row];
  
    cell.name1.text = route.name;
  
    /*
    [cell.contentView addSubview:[[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:route.color] andFrame:CGRectMake(80, 15, 13, 13)]];
     */
    YMRoundView *roundView = [[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:route.color] andFrame:CGRectMake(0, 0, 1, 1)];
    [cell.contentView addSubview:roundView];
    roundView.translatesAutoresizingMaskIntoConstraints = NO;
    [roundView autoSetDimensionsToSize:CGSizeMake(13, 13)];
    [roundView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [roundView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80];
    
    cell.accessoryView = ([route.inactive boolValue]) ? nil : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
  
    cell.name1.textColor = [YMTheme white];
  
    return cell;
  } else {
    YMShuttleSelectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Shuttle Selection Cell"];
    cell.name1.text = @"Confirm";
    cell.name1.textColor = [YMTheme white];
    return cell;
  }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Shuttle Refresh"];

  if (indexPath.section == 0) {
    Route *route = [self.routes objectAtIndex:indexPath.row];
    
    if ([route.inactive boolValue]) {
      route.inactive = [NSNumber numberWithBool:NO];
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@_inactive", route.routeid]];
    } else {
      route.inactive = [NSNumber numberWithBool:YES];
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_inactive", route.routeid]];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = ([route.inactive boolValue]) ? nil : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  // Confirm button was pressed
  if (indexPath.section == 1) {
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
  }
}

@end
