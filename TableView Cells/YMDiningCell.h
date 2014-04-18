//
//  YMDiningCell.h
//  YaleMobile
//
//  Created by Danqing on 2/8/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDiningCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) IBOutlet UILabel *special;
@property (nonatomic, strong) IBOutlet UIImageView *crowdedness;
@property (nonatomic, strong) IBOutlet UILabel *crowdLabel;

@end
