//
//  YMMainView.m
//  YaleMobile
//
//  Created by Danqing on 7/20/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMMainView.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"
#import "YMTheme.h"

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
  self.greeting.textColor    = [YMTheme YMTeal];
  self.condition.textColor   = [YMTheme YMBluebookBlue];
  self.temperature.textColor = [YMTheme mainViewTemperatureLabelColor];
  
  for (NSInteger i = 1; i <= 5; i++) {
    UILabel *dayLabel = [self valueForKey:[NSString stringWithFormat:@"day%ld", (long)i]];
    UILabel *tempLabel = [self valueForKey:[NSString stringWithFormat:@"temp%ld", (long)i]];
    dayLabel.textColor = [YMTheme mainViewTemperatureLabelColor];
    tempLabel.textColor = [YMTheme YMBluebookBlue];
  }
  
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
      self.greeting.textColor = [YMTheme YMDiningRed];
      [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"psa"];
    }
  }];
}

- (void)configureWeatherSubviews:(NSArray *)weatherInfo
{
  if (weatherInfo.count == 0) return;
  
  NSDictionary *current = [weatherInfo objectAtIndex:0];
  self.temperature.text = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSString stringWithFormat:@"%@°C",current[@"temp"]] : [NSString stringWithFormat:@"%@°F",current[@"temp"]];
  self.condition.text = [NSString stringWithFormat:@"%@ and", current[@"text"]];
  self.weather.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[current[@"code"] integerValue]]];
  
  NSString *overlay = [YMGlobalHelper getBgNameForWeather:[current[@"code"] integerValue]];
  if (overlay.length) {
    UIImageView *layer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlay]];
    layer.alpha = 0.8;
    [self addSubview:layer];
  }
  
  DLog(@"code is %@", [current objectForKey:@"code"]);
  
  if (weatherInfo.count == 1) return;
  
  for (NSInteger i = 1; i <= 5; i++) {
    NSDictionary *day = [weatherInfo objectAtIndex:i];
    UILabel *dayLabel = [self valueForKey:[NSString stringWithFormat:@"day%ld", (long)i]];
    UILabel *tempLabel = [self valueForKey:[NSString stringWithFormat:@"temp%ld", (long)i]];
    UIImageView *weatherImageView = [self valueForKey:[NSString stringWithFormat:@"weather%ld", (long)i]];
    dayLabel.text = day[@"day"];
    tempLabel.text = [NSString stringWithFormat:@"%@/%@", day[@"high"], day[@"low"]];
    weatherImageView.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[day[@"code"] integerValue]]];
  }

}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self _commonInit];
}

@end
