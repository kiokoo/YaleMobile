//
//  MKPolyline+EncodedString.h
//  YaleMobile
//
//  Created by Danqing on 6/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPolyline (EncodedString)

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString;

@end
