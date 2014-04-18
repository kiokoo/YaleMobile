//
//  YMCHelper.m
//  YaleMobile
//
//  Created by Danqing on 7/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMCHelper.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

CGMutablePathRef createShuttlePath(CGContextRef context, CGRect rect)
{
    CGFloat radius = 10;
    CGPoint center = CGPointMake(15, 15);
    CGPoint endpoint = CGPointMake(15, 37);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, radians(120), radians(60), 0);
    CGPathAddLineToPoint(path, NULL, endpoint.x, endpoint.y);
    CGPathCloseSubpath(path);
    
    return path;
}

CGMutablePathRef createArrowPath(CGContextRef context, CGRect rect, float degree)
{
    CGFloat radius = 6;
    CGFloat sradius = 3;
    CGPoint center = CGPointMake(15, 15);
    
    degree -= 90;
    
    CGPoint head = CGPointMake(center.x + cosf(radians(degree)) * radius, center.x + sinf(radians(degree)) * radius);
    
    float tdegree = degree + 180;    
    float tdegree1 = tdegree + 40;
    float tdegree2 = tdegree - 40;
    //if (tdegree > 360) tdegree -= 360; if (tdegree1 > 360) tdegree1 -= 360; if (tdegree2 > 360) tdegree2 -= 360;
    
    CGPoint tail1 = CGPointMake(center.x + cosf(radians(tdegree1)) * radius, center.x + sinf(radians(tdegree1)) * radius);
    CGPoint tail2 = CGPointMake(center.x + cosf(radians(tdegree2)) * radius, center.x + sinf(radians(tdegree2)) * radius);
    CGPoint tailmid = CGPointMake(center.x + cosf(radians(tdegree)) * sradius, center.x + sinf(radians(tdegree)) * sradius);
        
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, head.x, head.y);
    CGPathAddLineToPoint(path, NULL, tail1.x, tail1.y);
    CGPathAddLineToPoint(path, NULL, tailmid.x, tailmid.y);
    CGPathAddLineToPoint(path, NULL, tail2.x, tail2.y);
    CGPathCloseSubpath(path);

    return path;
}