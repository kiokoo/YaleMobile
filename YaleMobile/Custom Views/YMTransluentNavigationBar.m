//
//  YMTransluentNavigationBar.m
//  YaleMobile
//
//  Created by Hengchu Zhang on 8/21/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMTransluentNavigationBar.h"
#import "YMTheme.h"

@interface YMTransluentNavigationBar ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation YMTransluentNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 0.5f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (void)setBarTintColor:(UIColor *)barTintColor {
  [super setBarTintColor:barTintColor];
  if (self.colorLayer == nil) {
    self.colorLayer = [CALayer layer];
    self.colorLayer.opacity = kDefaultColorLayerOpacity;
    [self.layer addSublayer:self.colorLayer];
  }
  self.colorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.shadowImage = [UIImage new];
  if (self.colorLayer != nil) {
    self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
    
    [self.layer insertSublayer:self.colorLayer atIndex:1];
  }
}

@end
