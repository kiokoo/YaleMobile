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
#import "YMGlobalHelper.h"

#import <SWRevealViewController/SWRevealViewController.h>

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
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu.png"]];
  
  [self.tableView registerClass:[YMMenuCell class] forCellReuseIdentifier:@"Menu Cell"];
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
  [cell updateConstraintsIfNeeded];
  [cell layoutIfNeeded];
  cell.name1.textColor = [YMTheme white];
  cell.name1.text = [self.items objectAtIndex:indexPath.row];
  NSString *imageName = [NSString stringWithFormat:@"icon_sidebar_%@", [(NSString *)self.iconNames[indexPath.row] lowercaseString]];
  UIImage *icon = [UIImage imageNamed:imageName];
  cell.icon1.image = icon ? icon : [UIImage imageNamed:[NSString stringWithFormat:@"menu%ld.png", (long)indexPath.row]];
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
                                                forCell:cell];
  
  return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [[self.items objectAtIndex:indexPath.row] stringByAppendingString:@" Root"];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
  [newTopViewController.navigationController.navigationBar setBarTintColor:[YMTheme blue]];
  
  [self.revealViewController pushFrontViewController:newTopViewController animated:YES];
}

@end
