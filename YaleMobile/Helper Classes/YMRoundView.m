//
//  YMRoundView.m
//  YaleMobile
//
//  Created by Danqing on 6/19/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMRoundView.h"
#import "YMCHelper.h"

@interface YMRoundView ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation YMRoundView

- (id)initWithColor:(UIColor *)color andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)redrawWithColor:(UIColor *)color
{
    self.color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *lightColor = [self.color colorWithAlphaComponent:0.6];
    UIColor *darkColor = self.color;
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, darkColor.CGColor, lightColor.CGColor);
}

@end
