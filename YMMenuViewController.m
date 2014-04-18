//
//  YMMenuViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMenuViewController.h"
#import "ECSlidingViewController.h"
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
    cell.name.text = [self.items objectAtIndex:indexPath.row];
    cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu%d.png", indexPath.row]];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
    
    cell.name.shadowColor = [UIColor blackColor];
    cell.name.shadowOffset = CGSizeMake(0, 1);
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[self.items objectAtIndex:indexPath.row] stringByAppendingString:@" Root"];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end
