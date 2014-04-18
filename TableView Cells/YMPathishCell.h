//
//  YMPathishCell.h
//  YaleMobile
//
//  Created by Danqing on 1/2/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPathishCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *line;
@property (nonatomic, strong) IBOutlet UIImageView *dot;
@property (nonatomic, strong) IBOutlet UILabel *primary;
@property (nonatomic, strong) IBOutlet UILabel *secondary;

@end
