//
//  YMShuttleSelectionViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMShuttleSelectionViewController.h"
#import "YMShuttleSelectionCell.h"
#import "YMGlobalHelper.h"
#import "YMDatabaseHelper.h"
#import "YMRoundView.h"
#import "Route.h"

@interface YMShuttleSelectionViewController ()

@end

@implementation YMShuttleSelectionViewController

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
    /*if (self.db)
        [self loadData];
    else {
        [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {
            self.db = document;
            [YMDatabaseHelper setManagedDocumentTo:document];
            [self loadData];
        }];
    }*/
    [self.tableView reloadData];
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
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMShuttleSelectionCell *cell = (YMShuttleSelectionCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Shuttle Selection Cell"];
    
    Route *route = [self.routes objectAtIndex:indexPath.row];
    
    cell.name.text = route.name;

    [cell.contentView addSubview:[[YMRoundView alloc] initWithColor:[YMGlobalHelper colorFromHexString:route.color] andFrame:CGRectMake(60, 15, 13, 13)]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menubg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rightmenubg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 20)]];
    cell.accessoryView = ([route.inactive boolValue]) ? nil : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Shuttle Refresh"];

    Route *route = [self.routes objectAtIndex:indexPath.row];
    
    if ([route.inactive boolValue]) {
        route.inactive = [NSNumber numberWithBool:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@_inactive", route.routeid]];
    } else {
        route.inactive = [NSNumber numberWithBool:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_inactive", route.routeid]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = ([route.inactive boolValue]) ? nil : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
}

@end
