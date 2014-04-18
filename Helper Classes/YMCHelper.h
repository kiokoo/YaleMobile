//
//  YMCHelper.h
//  YaleMobile
//
//  Created by Danqing on 7/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
CGMutablePathRef createShuttlePath(CGContextRef context, CGRect rect);
CGMutablePathRef createArrowPath(CGContextRef context, CGRect rect, float degree);
