//
//  YMLaundryDetailCell.h
//  YaleMobile
//
//  Created by Danqing on 2/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLaundryDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *machineID;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *min;
@property (nonatomic, strong) IBOutlet UIImageView *alert;

@end
