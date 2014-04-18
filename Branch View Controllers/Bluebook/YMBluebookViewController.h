//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBluebookViewController : UITableViewController <UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *courses;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSString *exactPhrase;
@property (nonatomic, strong) NSString *courseNumber;
@property (nonatomic, strong) NSString *instructorName;
@property (nonatomic, strong) UIView *disableViewOverlay;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
           
@end
