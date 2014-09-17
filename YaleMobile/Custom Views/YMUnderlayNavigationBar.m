//
//  YMUnderlayNavigationBar.m
//  YaleMobile
//
//  Created by Hengchu Zhang on 9/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMUnderlayNavigationBar.h"

@interface YMUnderlayNavigationBar ()
{
  UIView* _underlayView;
}

- (UIView*) underlayView;

@end

@implementation YMUnderlayNavigationBar

- (void) didAddSubview:(UIView *)subview
{
  [super didAddSubview:subview];
  
  if(subview != _underlayView)
  {
    UIView* underlayView = self.underlayView;
    [underlayView removeFromSuperview];
    [self insertSubview:underlayView atIndex:1];
  }
}

- (UIView*) underlayView
{
  if(_underlayView == nil)
  {
    const CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    const CGSize selfSize = self.frame.size;
    
    _underlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, selfSize.width, selfSize.height + statusBarHeight)];
    [_underlayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [_underlayView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.34f blue:0.62f alpha:1.0f]];
    [_underlayView setAlpha:0.36f];
    [_underlayView setUserInteractionEnabled:NO];
  }
  
  return _underlayView;
}

@end