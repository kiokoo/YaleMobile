//
//  UIImage+Emboss.h
//  MTRMobile
//
//  Created by Danqing Liu on 7/27/12.
//  Copyright (c) 2012 DanqingBlue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Emboss)

+ (UIImage *)imageWithInteriorShadowAndString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size;
+ (UIImage *)imageWithUpwardShadowAndImage:(UIImage *)image;

@end
