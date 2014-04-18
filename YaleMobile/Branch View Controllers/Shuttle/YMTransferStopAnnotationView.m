//
//  YMTransferStopAnnotationView.m
//  YaleMobile
//
//  Created by Danqing on 7/17/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMTransferStopAnnotationView.h"
#import "YMStopAnnotation.h"
#import "Route.h"
#import "YMGlobalHelper.h"

@implementation YMTransferStopAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect f = self.frame;
        f.size.height = 20;
        f.size.width = 20;
        self.frame = f;
        self.opaque = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
	float startDeg = 0;
	float endDeg = 0;
	
	float x = self.bounds.origin.x + self.bounds.size.width / 2;
	float y = self.bounds.origin.y + self.bounds.size.height / 2;
	float r = self.bounds.size.height / 2 * 0.8;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *routes = ((YMStopAnnotation *)self.annotation).routes;
    float increment = 360.0 / routes.count;
    for (Route *route in routes) {
        UIColor *color = [YMGlobalHelper colorFromHexString:route.color];
        
        endDeg += increment;
        if (endDeg > 359) endDeg = 360;
        
        if (startDeg != endDeg) {
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, r, (startDeg-90)*M_PI / 180.0, (endDeg-90)*M_PI / 180.0, 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
        
        startDeg = endDeg;
    }
}

@end
