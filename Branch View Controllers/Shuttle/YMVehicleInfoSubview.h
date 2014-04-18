//
//  YMVehicleInfoSubview.h
//  YaleMobile
//
//  Created by Danqing on 7/17/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMVehicleInfoSubview : UIView

@property (nonatomic, strong) IBOutlet UILabel *route;
@property (nonatomic, strong) IBOutlet UILabel *vehicleNumber;
@property (nonatomic, strong) IBOutlet UILabel *nextStop;
@property (nonatomic, strong) IBOutlet UILabel *stop;

@end
