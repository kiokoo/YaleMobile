//
//  UIImage+Emboss.m
//  MTRMobile
//
//  Created by Danqing Liu on 7/27/12.
//  Copyright (c) 2012 DanqingBlue. All rights reserved.
//

#import "UIImage+Emboss.h"

@implementation UIImage (Emboss)

+ (UIImage *)maskWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size
{
    CGRect rect = {CGPointZero, size};
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef grayScale = CGColorSpaceCreateDeviceGray();
    CGContextRef gc = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, size.width * scale, grayScale, kCGImageAlphaOnly);
    CGContextScaleCTM(gc, scale, scale);
    CGColorSpaceRelease(grayScale);
    UIGraphicsPushContext(gc); {
        [[UIColor whiteColor] setFill];
        [string drawInRect:rect withFont:font];
    } UIGraphicsPopContext();
    
    CGImageRef cgImage = CGBitmapContextCreateImage(gc);
    CGContextRelease(gc);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    
    return image;
}

+ (UIImage *)invertedMaskWithMask:(UIImage *)mask
{
    CGRect rect = {CGPointZero, mask.size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, mask.scale); {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithInteriorShadowAndString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor size:(CGSize)size
{
    CGRect rect = {CGPointZero, size};
    UIImage *mask = [self maskWithString:string font:font size:rect.size];
    UIImage *invertedMask = [self invertedMaskWithMask:mask];
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale); {
        CGContextRef gc = UIGraphicsGetCurrentContext();
        // Clip to the mask that only allows drawing inside the string's image
        // We draw through the mask twice, otherwise the edges would be too sharp   
        CGContextClipToMask(gc, rect, mask.CGImage);
        CGContextClipToMask(gc, rect, mask.CGImage);
        mask = nil;
        
        // apply fill color
        [textColor setFill];
        CGContextFillRect(gc, rect);
        
        // draw interior shadow
        CGContextSetShadowWithColor(gc, CGSizeZero, 1.6, [UIColor colorWithWhite:.3 alpha:.1].CGColor);
        [invertedMask drawAtPoint:CGPointZero];
        invertedMask = nil;
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithUpwardShadowAndImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale); {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, -1), 1, [UIColor colorWithWhite:0 alpha:.15].CGColor);
        [image drawAtPoint:CGPointZero];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
