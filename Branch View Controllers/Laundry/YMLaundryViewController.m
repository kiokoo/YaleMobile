//
//  YMLaundryViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YMLaundryViewController.h"
#import "YMLaundryDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"
#import "YMLaundryCell.h"
#import "YMSimpleCell.h"
#import "UIColor+YaleMobile.h"

@interface YMLaundryViewController ()

@end

@implementation YMLaundryViewController

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
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Laundry" ofType:@"plist"];
    self.locations = [[NSArray alloc] initWithContentsOfFile:path];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Laundry URL" ofType:@"plist"];
    self.url = [[NSArray alloc] initWithContentsOfFile:path2];
    
    self.data = nil;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [YMServerCommunicator cancelAllHTTPRequests];

    [YMGlobalHelper setupSlidingViewControllerForController:self];
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.data == nil) [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) return YES;
    return NO;
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)refresh
{
    [YMServerCommunicator getAllLaundryStatusForController:self usingBlock:^(NSArray *data) {
        self.data = data;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YMLaundryDetailViewController *ldvc = (YMLaundryDetailViewController *)[segue destinationViewController];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    ldvc.roomCode = [self.url objectAtIndex:selected.row - 1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Header"];
        cell.name.text = @"Select a location";
        return cell;
    } else {
        YMLaundryCell *cell;
        cell = (indexPath.row == 1) ? (YMLaundryCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Cell Top"] : (YMLaundryCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Cell Middle"];
        
        cell.location.text = [self.locations objectAtIndex:indexPath.row - 1];
        
        if (self.data) {
            NSString *washerCount = [[self.data objectAtIndex:indexPath.row - 1] objectAtIndex:0];
            NSString *dryerCount = [[self.data objectAtIndex:indexPath.row - 1] objectAtIndex:1];
            cell.washer.text = [NSString stringWithFormat:@"Washers: %@", washerCount];
            cell.dryer.text = [NSString stringWithFormat:@"Dryers: %@", dryerCount];
            cell.userInteractionEnabled = YES;
            
            cell.washer.textColor = [UIColor lightGrayColor];
            cell.dryer.textColor = [UIColor lightGrayColor];
            
            if ([washerCount isEqualToString:@"0"]) {
                cell.washer.textColor = [UIColor YMBluebookOrange];
                cell.washer.highlightedTextColor = [UIColor YMOrange];
            }

            if ([dryerCount isEqualToString:@"0"]) {
                cell.dryer.textColor = [UIColor YMBluebookOrange];
                cell.dryer.highlightedTextColor = [UIColor YMOrange];
            }
        } else {
            cell.washer.text = @"Pls refresh";
            cell.dryer.text = @"Pull to refresh";
            cell.userInteractionEnabled = NO;
        }
        
        if (indexPath.row == 1) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == self.locations.count) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
        
        cell.backgroundView.alpha = 0.6;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 38;
    else if (indexPath.row == 1) return 67;
    else if (indexPath.row == self.locations.count) return 65;
    else return 57;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Laundry Segue" sender:self];
}

@end
