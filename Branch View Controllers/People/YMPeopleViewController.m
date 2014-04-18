//
//  YMPeopleViewController.m
//  YaleMobile
//
//  Created by Danqing on 12/25/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMPeopleViewController.h"
#import "YMServerCommunicator.h"
#import "YMSimpleCell.h"
#import "YMSubtitleCell.h"
#import "YMPeopleDetailViewController.h"
#import "YMGlobalHelper.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"

@interface YMPeopleViewController ()

@end

@implementation YMPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 700)];
    self.searchOverlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"peopleoverlay.png"]];
    
    [YMGlobalHelper addMenuButtonToController:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self restoreViewToDefault];
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

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YMPeopleDetailViewController *pdvc = (YMPeopleDetailViewController *)[segue destinationViewController];
    pdvc.data = self.individualData;
}

# pragma mark - search bar methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(restoreViewToDefault) userInfo:nil repeats:NO];
    self.searchOverlay.alpha = 0;
    [self.view addSubview:self.searchOverlay];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 1;
    [UIView commitAnimations];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self hideKeyboard];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self hideKeyboard];
    self.defaultBackground.hidden = YES;        
    NSString *searchString = ([searchBar.text.lowercaseString isEqualToString:@"person danqing loves"]) ? [@"Tong Zuo" stringByReplacingOccurrencesOfString:@" " withString:@"+"] : [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://directory.yale.edu/phonebook/index.htm?searchString=%@", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *responseString = operation.responseString;
        
        if ([responseString rangeOfString:@"Your search results:"].location != NSNotFound) {
            self.individualData = [YMServerCommunicator getInformationForPerson:responseString];
            [self performSegueWithIdentifier:@"People Detail Segue" sender:self];
        } else if ([responseString rangeOfString:@"No results found."].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                        message:@"Your search returned no results. You may expand your search by adding the '*' wildcard."
                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else if ([responseString rangeOfString:@"Your search returned too many results."].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too Many Results"
                        message:@"The Yale Phonebook server limits the number of results to be at most 25. Please be more specific."
                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            self.people = [YMServerCommunicator getPeopleList:responseString];
            [self.tableView reloadData];
            [self animateTableUp];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                    message:@"YaleMobile is unable to reach Yale Phonebook server. Please check your Internet connection and try again."
                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Searching...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [operation start];
}

- (void)hideKeyboard
{
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.2];
    self.searchOverlay.alpha = 0;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(removeOverlay:) userInfo:nil repeats:NO];
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)removeOverlay:(NSTimer *)timer
{
    [self.searchOverlay removeFromSuperview];
}

- (void)animateTableUp
{
    CGRect frame = self.tableView.frame;
    frame.origin.y += 700;
    self.tableView.frame = frame;
    self.tableView.hidden = NO;
    frame.origin.y -= 700;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = frame;
    }];
}

- (void)restoreViewToDefault
{
    self.tableView.hidden = YES;
    self.defaultBackground.hidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.people.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"People Header"];
        cell.name.text = [NSString stringWithFormat:@"Found %d results", self.people.count];
        return cell;
    } else {
        YMSubtitleCell *cell = (indexPath.row == 1) ? (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"People Top Cell"] : (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"People Cell"];
        if (indexPath.row == 1) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == self.people.count) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        } else {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
        cell.primary.text = [((NSDictionary *)[self.people objectAtIndex:indexPath.row-1]) objectForKey:@"name"];
        NSString *detail = [((NSDictionary *)[self.people objectAtIndex:indexPath.row-1]) objectForKey:@"info"];
        if (detail.length == 0) detail = @"Click to view details";
        cell.secondary.text = detail;
        
        cell.backgroundView.alpha = 0.6;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 38;
    } else if (indexPath.row == 1 || indexPath.row == self.people.count) {
        return 64;
    } else {
        return 54;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    NSString *urlString = [[self.people objectAtIndex:indexPath.row-1] objectForKey:@"link"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *responseString = operation.responseString;
        self.individualData = [YMServerCommunicator getInformationForPerson:responseString];
        [self performSegueWithIdentifier:@"People Detail Segue" sender:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                         message:@"YaleMobile is unable to reach Yale Phonebook server. Please check your Internet connection and try again."
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [operation start];
}

@end
