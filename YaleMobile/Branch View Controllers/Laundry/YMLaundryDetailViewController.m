//
//  YMLaundryDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMLaundryDetailViewController.h"
#import "YMServerCommunicator.h"
#import "YMGlobalHelper.h"
#import "YMSimpleCell.h"
#import "YMLaundryDetailCell.h"
#import "UIColor+YaleMobile.h"
#import "MBProgressHUD.h"

@interface YMLaundryDetailViewController ()

@end

@implementation YMLaundryDetailViewController

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
    [YMGlobalHelper addBackButtonToController:self];
    self.washers = nil;
    self.dryers = nil;
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh
{
    [YMServerCommunicator getLaundryStatusForLocation:self.roomCode forController:self usingBlock:^(NSArray *washers, NSArray *dryers, NSArray *machineStatuses) {
        self.washers = washers;
        self.dryers = dryers;
        self.machineStatuses = machineStatuses;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)getNumberOfRowsForSection:(NSInteger)section
{
    if (section == 0)
        return (self.washers != nil) ? ([[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue] + 1) : 0;
    else
        return (self.dryers != nil) ? ([[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue] + 1) : 0;
}

- (void)alertViewCallback
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UILocalNotification *)correspondingNotification:(NSString *)machineID
{
    for (UILocalNotification *not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[not.userInfo objectForKey:@"room"] isEqualToString:self.roomCode] && [[not.userInfo objectForKey:@"machine"] isEqualToString:machineID])
            return not;
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getNumberOfRowsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Header"];
        cell.name.text = (indexPath.section == 0) ? [NSString stringWithFormat:@"Washers: %@ of %@ available", [self.washers objectAtIndex:0], [self.washers objectAtIndex:1]] : [NSString stringWithFormat:@"Dryers: %@ of %@ available", [self.dryers objectAtIndex:0], [self.dryers objectAtIndex:1]];
        return cell;
    }
    
    YMLaundryDetailCell *cell;
    cell = (indexPath.row == 1) ? (YMLaundryDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Cell Top"] : (YMLaundryDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Laundry Detail Cell"];
    
    NSUInteger index = indexPath.section * [[self.washers objectAtIndex:1] integerValue] + indexPath.row - 1;
    
    NSString *machineID = [NSString stringWithFormat:@"%@", [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allKeys] objectAtIndex:0]];
    cell.machineID.text = [NSString stringWithFormat:@"#%@", machineID];
    NSString *status = [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allValues] objectAtIndex:0];
    
    [cell.time setHidden:true]; [cell.min setHidden:true]; [cell.status setHidden:false]; [cell.alert setHidden:YES]; cell.userInteractionEnabled = NO;
    
    if ([status rangeOfString:@"available"].location != NSNotFound) {
        cell.status.text = @"Available";
        cell.status.textColor = [UIColor YMGreen];
    } else if ([status rangeOfString:@"cycle has ended"].location != NSNotFound) {
        cell.status.text = @"Cycle Ended";
        cell.status.textColor = [UIColor YMLaundryOrange];
    } else if ([status rangeOfString:@"extended cycle"].location != NSNotFound) {
        cell.status.text = @"Extended Cycle";
        cell.status.textColor = [UIColor colorWithRed:229/255.0 green:73/255.0 blue:45/255.0 alpha:1];
    } else if ([status rangeOfString:@"est. time"].location != NSNotFound) {
        cell.status.text = @"minutes left";
        cell.status.textColor = [UIColor grayColor];
        NSString *time = [status stringByReplacingOccurrencesOfString:@"est. time remaining" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@"min" withString:@""];
        cell.time.text = time;
        [cell.time setHidden:false];
        [cell.min setHidden:false];
        [cell.status setHidden:true];
        if (time.integerValue > 5) {
            [cell.alert setHidden:NO];
            cell.userInteractionEnabled = YES;
            cell.alert.image = ([self correspondingNotification:machineID] != nil) ? [UIImage imageNamed:@"alert_active.png"] : [UIImage imageNamed:@"alert.png"];
        }
    } else if ([status rangeOfString:@"out of service"].location != NSNotFound) {
        cell.status.text = @"Out of Service";
        cell.status.textColor = [UIColor grayColor];
    } else {
        cell.status.text = @"Status Unknown";
        cell.status.textColor = [UIColor grayColor];
    }
    
    if (indexPath.row == 1) {
        if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
            (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        }
    } else if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
               (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    cell.backgroundView.alpha = 0.6;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 38;
    else if ([self getNumberOfRowsForSection:indexPath.section] == 2 && indexPath.row == 1) return 64;
    else if (indexPath.row == 1) return 56;
    else if ((indexPath.section == 0 && indexPath.row == [[self.washers objectAtIndex:1] integerValue] + [[self.washers objectAtIndex:2] integerValue]) ||
             (indexPath.section == 1 && indexPath.row == [[self.dryers objectAtIndex:1] integerValue] + [[self.dryers objectAtIndex:2] integerValue])) return 54;
    else return 46;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;

    NSUInteger index = indexPath.section * [[self.washers objectAtIndex:1] integerValue] + indexPath.row - 1;
    NSString *machineID = [NSString stringWithFormat:@"%@", [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allKeys] objectAtIndex:0]];
    
    UILocalNotification *not = [self correspondingNotification:machineID];
    if (not != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:not];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"Alert cancelled for machine %@", machineID];
        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertViewCallback) userInfo:nil repeats:NO];
        return;
    }
    
    NSString *status = [[(NSDictionary *)[self.machineStatuses objectAtIndex:index] allValues] objectAtIndex:0];
    NSInteger time = [[status stringByReplacingOccurrencesOfString:@"est. time remaining" withString:@""] stringByReplacingOccurrencesOfString:@"min" withString:@""].integerValue;
    NSInteger timeInSeconds = (time - 5) * 60;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInSeconds];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.roomCode, @"room", machineID, @"machine", nil];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = dict;
    notification.alertBody = @"Your laundry machine will finish running in 5 minutes. It's time to go pick up your laundry!";
    notification.alertAction = nil;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"Alert set for machine %@", machineID];
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertViewCallback) userInfo:nil repeats:NO];
}

@end
