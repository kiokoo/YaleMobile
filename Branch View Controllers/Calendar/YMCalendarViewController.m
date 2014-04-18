//
//  YMCalendarViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/25/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMCalendarViewController.h"
#import "YMGlobalHelper.h"
#import "YMAcademicCalendarDetailViewController.h"
#import "YMSimpleCell.h"
#import "YMServerCommunicator.h"

@interface YMCalendarViewController ()

@end

@implementation YMCalendarViewController

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CalendarSchool" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.schools = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [YMGlobalHelper addMenuButtonToController:self];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Academic Calendar Segue"]) {
        YMAcademicCalendarDetailViewController *acdvc = segue.destinationViewController;
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        YMSimpleCell *cell = (YMSimpleCell *)[self.tableView cellForRowAtIndexPath:selected];
        acdvc.title = cell.name.text;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schools.count + 1;  // additional 1 is header
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSimpleCell *cell;
    
    if (indexPath.row == 0) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Calendar Cell 0"];
    else if (indexPath.row == 1) cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Calendar Cell 1"];
    else cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Calendar Cell 2"];
    
    if (indexPath.row == 0) {
        cell.name.text = @"Academic Calendars";
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.name.text = [self.schools objectAtIndex:indexPath.row - 1];
        cell.name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        if (indexPath.row == 1) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == self.schools.count) {
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
    if (indexPath.row == 0) {
        return 38;
    } else if (indexPath.row == 1 || indexPath.row == self.schools.count) {
        return 54;
    } else {
        return 44;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Academic Calendar Segue" sender:self];
}

@end
