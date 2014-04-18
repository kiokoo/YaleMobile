//
//  YMLaundryCell.h
//  YaleMobile
//
//  Created by Danqing on 1/4/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLaundryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) IBOutlet UILabel *washer;
@property (nonatomic, strong) IBOutlet UILabel *dryer;
@property (nonatomic, strong) IBOutlet UIImageView *washerIcon;
@property (nonatomic, strong) IBOutlet UIImageView *dryerIcon;

@end
