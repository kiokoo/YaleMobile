//
//  YMMainView.m
//  YaleMobile
//
//  Created by Danqing on 7/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMMainView.h"
#import "YMGlobalHelper.h"
#import "UIColor+YaleMobile.h"
#import "YMServerCommunicator.h"

@implementation YMMainView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self _commonInit];
  }
  return self;
}

- (void)_commonInit
{
  self.greeting.textColor = [UIColor YMTeal];
  
  NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
  
  name = (name) ? [NSString stringWithFormat:@", %@", name] : @"";
  
  // Display different background and greeting depending on current time
  NSInteger hour = [YMGlobalHelper getCurrentTime];
  
  switch (hour) {
    case 1:
      self.greeting.text = [NSString stringWithFormat:@"Good morning%@! It's a brand new day :)", name];
      break;
    case 2:
      self.greeting.text = [NSString stringWithFormat:@"Good afternoon%@! Hope you are enjoying your day :)", name];
      break;
    case 3:
      self.greeting.text = [NSString stringWithFormat:@"Good evening%@! Hope you've had a great day :)", name];
      break;
    default:
      self.greeting.text = [NSString stringWithFormat:@"Good night%@! Have some good rest :)", name];
  }
  
  [YMServerCommunicator getGlobalSpecialInfoWithCompletionBlock:^(NSArray *array) {
    NSInteger i = [[array objectAtIndex:0] integerValue];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"psa"] < i || [[array objectAtIndex:1] integerValue] != 0) {
      NSString *prefix = (name) ? [NSString stringWithFormat:@"Hey %@!", name] : @"Hey there!";
      self.greeting.text = [NSString stringWithFormat:@"%@ %@", prefix, [array objectAtIndex:2]];
      self.greeting.textColor = [UIColor YMDiningRed];
      [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"psa"];
    }
  }];
}

- (void)configureWeatherSubviews:(NSArray *)weatherInfo
{
  if (weatherInfo.count == 0) return;
  
  NSDictionary *current = [weatherInfo objectAtIndex:0];
  self.temperature.text = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSString stringWithFormat:@"%@°C",[current objectForKey:@"temp"]] : [NSString stringWithFormat:@"%@°F",[current objectForKey:@"temp"]];
  self.condition.text = [NSString stringWithFormat:@"%@ and", [current objectForKey:@"text"]];
  self.weather.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[current objectForKey:@"code"] integerValue]]];
  
  NSString *overlay = [YMGlobalHelper getBgNameForWeather:[[current objectForKey:@"code"] integerValue]];
  if (overlay.length) {
    UIImageView *layer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlay]];
    layer.alpha = 0.8;
    [self addSubview:layer];
  }
  
  DLog(@"code is %@", [current objectForKey:@"code"]);
  
  if (weatherInfo.count == 1) return;
  
  NSDictionary *day1 = [weatherInfo objectAtIndex:1];
  self.day1.text = [day1 objectForKey:@"day"];
  self.temp1.text = [NSString stringWithFormat:@"%@/%@", [day1 objectForKey:@"high"], [day1 objectForKey:@"low"]];
  self.weather1.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day1 objectForKey:@"code"] integerValue]]];
  
  if (weatherInfo.count == 2) return;
  
  NSDictionary *day2 = [weatherInfo objectAtIndex:2];
  self.day2.text = [day2 objectForKey:@"day"];
  self.temp2.text = [NSString stringWithFormat:@"%@/%@", [day2 objectForKey:@"high"], [day2 objectForKey:@"low"]];
  self.weather2.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day2 objectForKey:@"code"] integerValue]]];
  
  if (weatherInfo.count == 3) return;
  
  NSDictionary *day3 = [weatherInfo objectAtIndex:3];
  self.day3.text = [day3 objectForKey:@"day"];
  self.temp3.text = [NSString stringWithFormat:@"%@/%@", [day3 objectForKey:@"high"], [day3 objectForKey:@"low"]];
  self.weather3.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day3 objectForKey:@"code"] integerValue]]];
  
  if (weatherInfo.count == 4) return;
  
  NSDictionary *day4 = [weatherInfo objectAtIndex:4];
  self.day4.text = [day4 objectForKey:@"day"];
  self.temp4.text = [NSString stringWithFormat:@"%@/%@", [day4 objectForKey:@"high"], [day4 objectForKey:@"low"]];
  self.weather4.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day4 objectForKey:@"code"] integerValue]]];
  
  if (weatherInfo.count == 5) return;
  
  NSDictionary *day5 = [weatherInfo objectAtIndex:5];
  self.day5.text = [day5 objectForKey:@"day"];
  self.temp5.text = [NSString stringWithFormat:@"%@/%@", [day5 objectForKey:@"high"], [day5 objectForKey:@"low"]];
  self.weather5.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day5 objectForKey:@"code"] integerValue]]];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self _commonInit];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
