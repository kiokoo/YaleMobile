//
//  YMHoursListViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/17/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMHoursListViewController.h"
#import "YMGlobalHelper.h"
#import "YMSimpleCell.h"
#import "YMHoursLibraryViewController.h"

@interface YMHoursListViewController ()

@end

@implementation YMHoursListViewController

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
    self.keys = [[self.data allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [YMGlobalHelper addBackButtonToController:self];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.translucent = NO;
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    YMHoursLibraryViewController *hlvc = (YMHoursLibraryViewController *)segue.destinationViewController;
    hlvc.name = [self.keys objectAtIndex:self.selectedIndexPath.row - 1];
    hlvc.data = [self.data objectForKey:[self.keys objectAtIndex:self.selectedIndexPath.row - 1]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSimpleCell *cell;
    
    if (indexPath.row == 0) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours List Header"];
    else if (indexPath.row == 1) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours List Cell 1"];
    else cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours List Cell 2"];
    
    if (indexPath.row == 0) {
        cell.name.text = @"Select a Library";
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.name.text = [self.keys objectAtIndex:indexPath.row - 1];
        cell.name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        if (indexPath.row == 1) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == self.keys.count) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
    }
    
    cell.backgroundView.alpha = 0.6;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 38;
    else if (indexPath.row == 1 || indexPath.row == self.keys.count)
        return 54;
    else
        return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Hours Library Segue" sender:self];
}

@end
