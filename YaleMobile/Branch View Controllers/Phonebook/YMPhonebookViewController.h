//
//  YMPhonebookViewController.h
//  YaleMobile
//
//  Created by Danqing on 2/2/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface YMPhonebookViewController : CoreDataTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    NSFetchedResultsController *_searchResultsController;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *searchResultsController;
@property (nonatomic, strong) UIManagedDocument *database;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@end
