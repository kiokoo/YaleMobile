//
//  YMBluebookFilterSelectionViewController.m
//  YaleMobile
//
//  Created by iBlue on 1/15/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMBluebookFilterSelectionViewController.h"
#import "YMSimpleCell.h"
#import <QuartzCore/QuartzCore.h>

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

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg_table.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.selected = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Bluebook %@", [self.options objectAtIndex:self.options.count - 1]]];
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
    return self.options.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Filter Selection Simple"];
    cell.name.text = [self.options objectAtIndex:indexPath.row];
    cell.name.shadowColor = [UIColor blackColor];
    cell.name.shadowOffset = CGSizeMake(0, 1);
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rightmenubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 20)]];
    cell.accessoryView = ([self.selected isEqualToString:cell.name.text]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]] : nil;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
	
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuheader.png"]];
    
    headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor lightGrayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:13];
	headerLabel.frame = CGRectMake(61.0, 0.0, 300.0, 22.0);
    
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    
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
    self.selected = cell.name.text;
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
