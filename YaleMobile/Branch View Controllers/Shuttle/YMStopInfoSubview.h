//
//  YMStopInfoSubview.h
//  YaleMobile
//
//  Created by Danqing on 7/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMRoundView;

@interface YMStopInfoSubview : UIView

@property (nonatomic, strong) IBOutlet UILabel *lineName;
@property (nonatomic, strong) IBOutlet UILabel *etaLabel;
@property (nonatomic, strong) IBOutlet UILabel *minutes;
@property (nonatomic, strong) IBOutlet UILabel *stopName;
@property (nonatomic, strong) IBOutlet UILabel *stopCode;

@property (nonatomic, strong) IBOutlet UIView *minutesFrame;
@property (nonatomic, strong) IBOutlet UIView *lineFrame;
@property (nonatomic, strong) IBOutlet UIView *etaFrame;

@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;
@property (nonatomic, strong) UILabel *eta1;
@property (nonatomic, strong) UILabel *eta2;
@property (nonatomic, strong) UILabel *minutes1;
@property (nonatomic, strong) UILabel *minutes2;

@property (nonatomic, strong) YMRoundView *dot1;
@property (nonatomic, strong) YMRoundView *dot2;

@property (nonatomic) NSInteger index;

@end
