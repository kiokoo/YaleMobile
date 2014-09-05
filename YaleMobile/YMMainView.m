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


@interface YMMainView ()

@property (nonatomic, strong) UIImageView *imageLayer;

@end

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
	self.temperature.text = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSString stringWithFormat:@"%@",current[@"temp"]] : [NSString stringWithFormat:@"%@",current[@"temp"]];
	self.condition.text = [NSString stringWithFormat:@"%@ and", current[@"text"]];
	self.weather.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[current[@"code"] integerValue]]];
	
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"°C/°F"];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"] == YES) {
		[attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:15] range:NSMakeRange(0, 5)];
		[attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
		[attrString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2, 3)];
	} else {
		
		[attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:15] range:NSMakeRange(0, 5)];
		[attrString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 3)];
		[attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(3, 2)];
	}
	
	[self.changeUnitsButton.titleLabel setAttributedText:attrString];
	
	NSString *overlay = [YMGlobalHelper getBgNameForWeather:[current[@"code"] integerValue]];
	if (overlay.length) {
		if (self.imageLayer)
			[self.imageLayer removeFromSuperview];
		self.imageLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlay]];
		self.imageLayer.alpha = 0.8;
		[self addSubview:self.imageLayer];
	}
	
	DLog(@"code is %@", [current objectForKey:@"code"]);
	
	if (weatherInfo.count == 1) return;
	
	for (NSInteger i = 1; i <= 5; i++) {
		NSDictionary *day = [weatherInfo objectAtIndex:i];
		UILabel *dayLabel = [self valueForKey:[NSString stringWithFormat:@"day%ld", i]];
		UILabel *tempLabel = [self valueForKey:[NSString stringWithFormat:@"temp%ld", i]];
		UIImageView *weatherImageView = [self valueForKey:[NSString stringWithFormat:@"weather%ld", i]];
		dayLabel.text = day[@"day"];
		tempLabel.text = [NSString stringWithFormat:@"%@/%@", day[@"high"], day[@"low"]];
		weatherImageView.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[day[@"code"] integerValue]]];
	}
    
}
- (IBAction)switchTemperatureUnits:(id)sender {
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"] == YES)
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Celsius"];
	else
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Celsius"];
	
	[YMServerCommunicator getWeatherWithCompletionBlock:^(NSArray *weatherInfo) {
		[self configureWeatherSubviews:weatherInfo];
	}];
	
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self _commonInit];
}

@end
