//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMMainView;

@interface YMMainViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) YMMainView *mainView;

@end
