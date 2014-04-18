//
//  YMBluebookFilterViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMBluebookFilterViewController.h"
#import "YMBluebookFilterSelectionViewController.h"
#import "YMSimpleCell.h"
#import "YMSubtitleCell.h"

@interface YMBluebookFilterViewController ()

@end

@implementation YMBluebookFilterViewController

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
    self.filters = @[@[@"Term", @"Category"], @[@"Humanities", @"Social Sciences", @"Sciences"], @[@"Language", @"Writing", @"Quantitative Reasoning"]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YMBluebookFilterSelectionViewController *fsvc = segue.destinationViewController;
    fsvc.options = self.options;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[self.filters objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || (indexPath.section == 2 && indexPath.row == 0)) {
        YMSubtitleCell *cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Filter Subtitle"];
        cell.primary.text = [((NSArray *)[self.filters objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        cell.secondary.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Bluebook %@", cell.primary.text]];
        cell.primary.shadowColor = [UIColor blackColor];
        cell.primary.shadowOffset = CGSizeMake(0, 1);
        cell.secondary.shadowColor = [UIColor blackColor];
        cell.secondary.shadowOffset = CGSizeMake(0, 1);
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
        return cell;
    } else {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Filter Simple"];
        cell.name.text = [((NSArray *)[self.filters objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        cell.name.shadowColor = [UIColor blackColor];
        cell.name.shadowOffset = CGSizeMake(0, 1);
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rightmenubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 20)]];
        cell.accessoryView = ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"Bluebook %@", cell.name.text]]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]] : nil;
        return cell;
    }

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
    
	if (section == 1) {
        headerLabel.text = @"Area Filters";
    } else if (section == 2) {
        headerLabel.text = @"Skill Filters";
    }
	
    [headerView addSubview:headerLabel];
    
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.0;
    return 25;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.options = @[@"Fall 2010", @"Spring 2011", @"Summer 2011", @"Fall 2011", @"Spring 2012", @"Summer 2012", @"Spring 2013", @"Fall 2013", @"Spring 2014", @"Term"];
        } else {
            self.options = @[@"ALL", @"Undergraduate", @"Graduate", @"Professional", @"Category"];
        }
        [self performSegueWithIdentifier:@"Bluebook Filter Segue" sender:self];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        self.options = @[@"None", @"Level 1", @"Level 2", @"Level 3", @"Level 4", @"Level 5", @"Language"];
        [self performSegueWithIdentifier:@"Bluebook Filter Segue" sender:self];
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryView == nil) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"Bluebook %@", ((YMSimpleCell *)cell).name.text]];
        } else {
            cell.accessoryView = nil;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"Bluebook %@", ((YMSimpleCell *)cell).name.text]];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
