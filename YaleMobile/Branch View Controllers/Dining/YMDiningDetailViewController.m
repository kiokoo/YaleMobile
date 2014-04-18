//
//  YMDiningDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMDiningDetailViewController.h"
#import "YMServerCommunicator.h"
#import "YMGlobalHelper.h"
#import "YMSubtitleCell.h"

@interface YMDiningDetailViewController ()

@end

@implementation YMDiningDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    [YMGlobalHelper addBackButtonToController:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.abbr]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.alpha = 0.7;
    [self updateTableHeader];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    float height = ([[UIScreen mainScreen] bounds].size.height == 568) ? 548 : 460;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    view.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_overlay.png", self.abbr]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view insertSubview:view belowSubview:self.tableView];
    self.overlay = view;
    view.alpha = 0;
    
    // inefficient code
    [YMServerCommunicator getDiningDetailForLocation:self.locationID forController:self usingBlock:^(NSArray *array) {
        if (!array || array.count == 0) {
            self.menu = nil;
            [self updateTableHeader];
            return;
        }
        NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSInteger i = 0; i < 5; i++) {
            NSMutableArray *sub = [[NSMutableArray alloc] initWithCapacity:array.count];
            [all addObject:sub];
        }
        
        for (NSArray *entry in array) {
            NSInteger i = [[entry objectAtIndex:4] integerValue] - 1;
            if (i >= 0 && i < 5) [[all objectAtIndex:i] addObject:entry];
        }
        for (NSInteger i = 4; i >= 0; i--) {
            if ([[all objectAtIndex:i] count] == 0) [all removeObjectAtIndex:i];
        }
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:all.count];
        for (NSMutableArray *entry in all) {
            NSString *text = [self parseSubmenu:entry];
            [result addObject:[[NSDictionary alloc] initWithObjectsAndKeys:text, [[entry objectAtIndex:1] objectAtIndex:3], nil]];
        }
        self.menu = result;
        [self updateTableHeader];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [YMServerCommunicator cancelAllHTTPRequests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

// inefficient code
- (NSString *)parseSubmenu:(NSMutableArray *)array
{
    NSInteger count = 0;
    for (NSArray *entry in array)
        if (count < [[entry objectAtIndex:8] integerValue])
            count = [[entry objectAtIndex:8] integerValue];
    
    NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSMutableArray *sub = [[NSMutableArray alloc] initWithCapacity:array.count + 1];
        [all addObject:sub];
    }
    for (NSArray *entry in array) {
        NSInteger i = [[entry objectAtIndex:8] integerValue] - 1;
        if ([[all objectAtIndex:i] count] == 0)
            [[all objectAtIndex:i] addObject:[NSString stringWithFormat:@"%@\n",[entry objectAtIndex:7]]];
        [[all objectAtIndex:i] addObject:[NSString stringWithFormat:@"\t\t\t\t› %@\n", [entry objectAtIndex:10]]];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSArray *entry in all)
        [result addObject:[entry componentsJoinedByString:@""]];
    
    return [result componentsJoinedByString:@""];
}


- (void)updateTableHeader
{
    float extra = ([[UIScreen mainScreen] bounds].size.height == 568) ? 336 : 248;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 140 + extra, 286, 28)];
    headerLabel.text = self.titleText;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.numberOfLines = 0;
    
    CGSize textSize = [self.titleText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame = headerLabel.frame;
    newFrame.size.height = textSize.height;
    headerLabel.frame = newFrame;
    
    UILabel *headerSublabel = [[UILabel alloc] initWithFrame:CGRectMake(24, headerLabel.frame.size.height + extra + 140, 286, 25)];
    headerSublabel.textColor = [UIColor whiteColor];
    headerSublabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerSublabel.backgroundColor = [UIColor clearColor];
    headerSublabel.numberOfLines = 0;
    headerSublabel.text = self.address;
    
    CGSize textSize2 = [self.address sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] constrainedToSize:CGSizeMake(286.0, 3000)];
    CGRect newFrame2 = headerSublabel.frame;
    newFrame2.size.height = textSize2.height;
    headerSublabel.frame = newFrame2;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150 + headerLabel.frame.size.height + headerSublabel.frame.size.height + extra)];
    
    [containerView addSubview:headerLabel];
    [containerView addSubview:headerSublabel];
    
    self.tableView.tableHeaderView = containerView;
    [self.tableView reloadData];    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    self.overlay.alpha = offset/400;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSubtitleCell *cell;

    if (indexPath.row == 0) cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Detail Cell 1"];
    else cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Dining Detail Cell 2"];
    
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        cell.secondary.text = @"Regular Hours";
        cell.primary.text = self.hour;
        CGSize textSize = [self.hour sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        CGRect frame = cell.primary.frame;
        frame.size.height = textSize.height;
    } else if (indexPath.row == 1 + self.menu.count) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.secondary.text = @"Special Events";
        cell.primary.text = self.special;
    } else {
        cell.secondary.text = [NSString stringWithFormat:@"Today's Menu - %@", [[[self.menu objectAtIndex:indexPath.row - 1] allKeys] objectAtIndex:0]];
        cell.primary.text = [[[self.menu objectAtIndex:indexPath.row - 1] allValues] objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"dtablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
    }
    
    cell.backgroundView.alpha = 0.4;
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 + self.menu.count) {
        CGSize textSize = [self.special sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        return textSize.height + 50;
    } else if (indexPath.row == 0) {
        CGSize textSize = [self.hour sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        return textSize.height + 50;
    } else {
        CGSize textSize = [[[[self.menu objectAtIndex:indexPath.row - 1] allValues] objectAtIndex:0] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
        return textSize.height + 40;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
}

@end
