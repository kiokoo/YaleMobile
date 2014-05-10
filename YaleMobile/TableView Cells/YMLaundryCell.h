//
//  YMLaundryCell.h
//  YaleMobile
//
//  Created by Danqing on 1/4/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLaundryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *location1;
@property (nonatomic, strong) IBOutlet UILabel *washer1;
@property (nonatomic, strong) IBOutlet UILabel *dryer1;
@property (nonatomic, strong) IBOutlet UIImageView *washerIcon1;
@property (nonatomic, strong) IBOutlet UIImageView *dryerIcon1;

@end
