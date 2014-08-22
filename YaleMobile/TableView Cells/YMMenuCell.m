//
//  YMMenuCell.m
//  YaleMobile
//
//  Created by Danqing on 12/23/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMenuCell.h"
#import <PureLayout/PureLayout.h>

@implementation YMMenuCell {
  BOOL _didSetupConstraints;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self _commonInit];
  }
  return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self _commonInit];
}

- (void)updateConstraints
{
  
  if (!_didSetupConstraints) {
    
    [self.icon1 autoSetDimensionsToSize:CGSizeMake(25, 25)];
    [self.icon1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.icon1 autoPinEdge:ALEdgeLeft
                     toEdge:ALEdgeLeft
                     ofView:self.contentView withOffset:16];
    
    [self.name1 autoAlignAxis:ALAxisHorizontal
             toSameAxisOfView:self.icon1
                   withOffset:-1];
    [self.name1 autoPinEdge:ALEdgeLeft
                     toEdge:ALEdgeRight
                     ofView:self.icon1 withOffset:16];
    [self.name1 autoSetDimensionsToSize:CGSizeMake(241, 25)];
    
    _didSetupConstraints = YES;
  }
  
  [super updateConstraints];
}

- (void)_commonInit
{
  self.name1 = [UILabel newAutoLayoutView];
  self.name1.textColor = [UIColor whiteColor];
  self.name1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
  
  self.icon1 = [UIImageView newAutoLayoutView];
  [self.contentView addSubview:self.name1];
  [self.contentView addSubview:self.icon1];
}
@end
