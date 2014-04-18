//
//  YMAcademicCalendarDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/28/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMAcademicCalendarDetailViewController.h"
#import "YMSimpleCell.h"
#import "YMPathishCell.h"
#import "YMGlobalHelper.h"

@interface YMAcademicCalendarDetailViewController ()

@end

@implementation YMAcademicCalendarDetailViewController

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
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    
    // customized back button (<-)
    [YMGlobalHelper addBackButtonToController:self];

    // actual contents to be displayed, fetched from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:self.title ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.calendar = dict;
    self.terms = [[self.calendar allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:self.terms.count];
    for (NSString *t in self.terms) {
        NSDictionary *oneTerm = [[NSDictionary alloc] initWithDictionary:[self.calendar objectForKey:t]];
        NSMutableArray *oneTermSorted = [[NSMutableArray alloc] initWithCapacity:oneTerm.count];
        NSArray *array = [[oneTerm allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *s in array) {
            NSDictionary *detailDict = [[NSDictionary alloc] initWithDictionary:[oneTerm objectForKey:s]];
            [oneTermSorted addObject:detailDict];
        }
        [detailArray addObject:oneTermSorted];
    }
    
    self.sorted = detailArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sorted.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[self.sorted objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *oneTerm = [self.sorted objectAtIndex:indexPath.section];
    NSDictionary *detailDict = [oneTerm objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Academic Calendar Header"];
        cell.name.text = [detailDict objectForKey:@"Term"];
        return cell;
    } else {
        YMPathishCell *cell;
        
        // set up cell appearance based on position
        if (indexPath.row == 1) {
            cell = (YMPathishCell *)[tableView dequeueReusableCellWithIdentifier:@"Academic Calendar Top"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == oneTerm.count - 1) {
            cell = (YMPathishCell *)[tableView dequeueReusableCellWithIdentifier:@"Academic Calendar Bottom"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        } else {
            cell = (YMPathishCell *)[tableView dequeueReusableCellWithIdentifier:@"Academic Calendar Middle"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
        
        cell.secondary.text = [detailDict objectForKey:@"Date"];
        cell.primary.text = [detailDict objectForKey:@"Event"];
        cell.dot.image = [UIImage imageNamed:[NSString stringWithFormat:@"round%@.png", [detailDict objectForKey:@"Type"]]];
        
        // adjust cell primary label height
        CGSize size = [cell.primary.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0] constrainedToSize:CGSizeMake(235.0, 5000.0)];
        CGRect frame = cell.primary.frame;
        frame.size.height = size.height;
        cell.primary.frame = frame;
        
        cell.backgroundView.alpha = 0.6;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 38;
    else {
        NSArray *oneTerm = [self.sorted objectAtIndex:indexPath.section];
        NSDictionary *detailDict = [oneTerm objectAtIndex:indexPath.row];
        NSString *text = [detailDict objectForKey:@"Event"];

        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0] constrainedToSize:CGSizeMake(235.0, 5000.0)];
        if (indexPath.row == 1) {
            return size.height + 48;
        } else if (indexPath.row == oneTerm.count - 1) {
            return size.height + 44;
        } else return size.height + 36;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
