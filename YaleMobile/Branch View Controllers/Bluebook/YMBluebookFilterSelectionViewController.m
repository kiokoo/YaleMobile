//
//  YMBluebookFilterSelectionViewController.m
//  YaleMobile
//
//  Created by iBlue on 1/15/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMBluebookFilterSelectionViewController.h"
#import "YMSimpleCell.h"
#import "YMGlobalHelper.h"
#import <QuartzCore/QuartzCore.h>

#import "YMTheme.h"

@interface YMBluebookFilterSelectionViewController ()

@end

@implementation YMBluebookFilterSelectionViewController

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
    
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.selected = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Bluebook %@", [self.options objectAtIndex:self.options.count - 1]]];
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
  return self.options.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Filter Selection Simple"];
  cell.name1.text = [self.options objectAtIndex:indexPath.row];

  cell.name1.textColor = [YMTheme white];
  
  cell.accessoryView = ([self.selected isEqualToString:cell.name1.text]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]] : nil;
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
                                                forCell:cell];
  
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
	
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  
  headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor lightGrayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:13];
	headerLabel.frame = CGRectMake(81.0, 0.0, 300.0, 22.0);
  
	headerLabel.text = [self.options objectAtIndex:self.options.count - 1];
	
  [headerView addSubview:headerLabel];
  
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 25;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSimpleCell *cell = (YMSimpleCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  self.selected = cell.name1.text;
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  [[NSUserDefaults standardUserDefaults] setObject:self.selected forKey:[NSString stringWithFormat:@"Bluebook %@", [self.options objectAtIndex:self.options.count - 1]]];
  [self.tableView reloadData];
  
  CATransition *transition = [CATransition animation];
  transition.duration = 0.5;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
  transition.type = kCATransitionFade;
  [self.navigationController.view.layer addAnimation:transition forKey:nil];
  [self.navigationController popViewControllerAnimated:NO];
}

@end
