//
//  YMStopAnnotationView.m
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMStopAnnotationView.h"
#import "YMStopAnnotation.h"
#import "YMGlobalHelper.h"
#import "Route.h"
#import "YMCHelper.h"

@implementation YMStopAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect f = self.frame;
        f.size.width = 10;
        f.size.height = 10;
        self.frame = f;
        self.opaque = NO;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *lightColor = [YMGlobalHelper colorFromHexString:((Route *)[((YMStopAnnotation *)self.annotation).routes objectAtIndex:0]).color];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *darkColor = [lightColor colorWithAlphaComponent:0.8];
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, darkColor.CGColor, lightColor.CGColor);
}


@end
