//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMainViewController.h"
#import "ECSlidingViewController.h"
#import "YMMenuViewController.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"
#import "YMMainView.h"
#import "YMSplashViewController.h"
#import "UIColor+YaleMobile.h"

@interface YMMainViewController ()

@end

@implementation YMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YMGlobalHelper setupUserDefaults];    
    [YMGlobalHelper addMenuButtonToController:self];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    
    NSLog(@"Loading");
    
    NSArray *views = ([[UIScreen mainScreen] bounds].size.height == 568) ? [[NSBundle mainBundle] loadNibNamed:@"YMMainView5" owner:self options:nil] : [[NSBundle mainBundle] loadNibNamed:@"YMMainView4" owner:self options:nil];
    for (id v in views) {
        if ([v isKindOfClass:[YMMainView class]]) {
            self.mainView = v;
            [self.view addSubview:v];
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"First Launch Passed"]) {
        [self performSegueWithIdentifier:@"First Launch Segue" sender:self];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First Launch Passed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Just Launched"];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Just Launched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Just Launched"];
        YMSplashViewController *splashScreen = [[YMSplashViewController alloc] init];
        [self presentViewController:splashScreen animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(splash:) userInfo:nil repeats:NO];
    }
}

- (void)splash:(NSTimer *)timer
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    self.name = (name) ? [NSString stringWithFormat:@", %@", name] : @"";
    
    [YMGlobalHelper setupSlidingViewControllerForController:self];
    [YMServerCommunicator getWeatherForController:self usingBlock:^(NSArray *array) {
        
        if (array.count == 0) return;
        
        NSDictionary *current = [array objectAtIndex:0];
        self.mainView.temperature.text = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSString stringWithFormat:@"%@°C",[current objectForKey:@"temp"]] : [NSString stringWithFormat:@"%@°F",[current objectForKey:@"temp"]];
        self.mainView.condition.text = [NSString stringWithFormat:@"%@ and", [current objectForKey:@"text"]];
        self.mainView.weather.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[current objectForKey:@"code"] integerValue]]];
        
        NSString *overlay = [YMGlobalHelper getBgNameForWeather:[[current objectForKey:@"code"] integerValue]];
        if (overlay.length) {
            UIImageView *layer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:overlay]];
            layer.alpha = 0.8;
            [self.view addSubview:layer];
        }
        
        NSLog(@"code is %@", [current objectForKey:@"code"]);
        
        if (array.count == 1) return;
        
        NSDictionary *day1 = [array objectAtIndex:1];
        self.mainView.day1.text = [day1 objectForKey:@"day"];
        self.mainView.temp1.text = [NSString stringWithFormat:@"%@/%@", [day1 objectForKey:@"high"], [day1 objectForKey:@"low"]];
        self.mainView.weather1.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day1 objectForKey:@"code"] integerValue]]];
        
        if (array.count == 2) return;
        
        NSDictionary *day2 = [array objectAtIndex:2];
        self.mainView.day2.text = [day2 objectForKey:@"day"];
        self.mainView.temp2.text = [NSString stringWithFormat:@"%@/%@", [day2 objectForKey:@"high"], [day2 objectForKey:@"low"]];
        self.mainView.weather2.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day2 objectForKey:@"code"] integerValue]]];
        
        if (array.count == 3) return;

        NSDictionary *day3 = [array objectAtIndex:3];
        self.mainView.day3.text = [day3 objectForKey:@"day"];
        self.mainView.temp3.text = [NSString stringWithFormat:@"%@/%@", [day3 objectForKey:@"high"], [day3 objectForKey:@"low"]];
        self.mainView.weather3.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day3 objectForKey:@"code"] integerValue]]];
        
        if (array.count == 4) return;

        NSDictionary *day4 = [array objectAtIndex:4];
        self.mainView.day4.text = [day4 objectForKey:@"day"];
        self.mainView.temp4.text = [NSString stringWithFormat:@"%@/%@", [day4 objectForKey:@"high"], [day4 objectForKey:@"low"]];
        self.mainView.weather4.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day4 objectForKey:@"code"] integerValue]]];

        if (array.count == 5) return;

        NSDictionary *day5 = [array objectAtIndex:5];
        self.mainView.day5.text = [day5 objectForKey:@"day"];
        self.mainView.temp5.text = [NSString stringWithFormat:@"%@/%@", [day5 objectForKey:@"high"], [day5 objectForKey:@"low"]];
        self.mainView.weather5.image = [UIImage imageNamed:[YMGlobalHelper getIconNameForWeather:[[day5 objectForKey:@"code"] integerValue]]];
    }];

    
    // Display different background and greeting depending on current time
    NSInteger hour = [YMGlobalHelper getCurrentTime];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    /*if (hour <= 2) {
        // if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay-568h@2x.png"]]];
        // else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGDay.png"]]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    } else {
        // if ([[UIScreen mainScreen] bounds].size.height == 568) [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight-568h@2x.png"]]];
        // else [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBGNight.png"]]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }*/
    
    self.mainView.greeting.textColor = [UIColor YMTeal];
    
    if (hour == 1) self.mainView.greeting.text = [NSString stringWithFormat:@"Good morning%@! It's a brand new day :)", self.name];
    else if (hour == 2) self.mainView.greeting.text = [NSString stringWithFormat:@"Good afternoon%@! Hope you are enjoying your day :)", self.name];
    else if (hour == 3) self.mainView.greeting.text = [NSString stringWithFormat:@"Good evening%@! Hope you've had a great day :)", self.name];
    else self.mainView.greeting.text = [NSString stringWithFormat:@"Good night%@! Have some good rest :)", self.name];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Tong"]) self.mainView.greeting.text = [self.mainView.greeting.text stringByReplacingOccurrencesOfString:@":)" withString:@"<3"];
    
    [YMServerCommunicator getGlobalSpecialInfoForController:self usingBlock:^(NSArray *array) {
        NSInteger i = [[array objectAtIndex:0] integerValue];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"psa"] < i || [[array objectAtIndex:1] integerValue] != 0) {
            NSString *prefix = (name) ? [NSString stringWithFormat:@"Hey %@!", name] : @"Hey there!";
            self.mainView.greeting.text = [NSString stringWithFormat:@"%@ %@", prefix, [array objectAtIndex:2]];
            self.mainView.greeting.textColor = [UIColor YMDiningRed];
            [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"psa"];
        }
    }];
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

@end
