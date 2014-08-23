//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMMainViewController.h"
#import "YMMenuViewController.h"
#import "YMGlobalHelper.h"
#import "YMServerCommunicator.h"
#import "YMMainView.h"
#import "YMSplashViewController.h"
#import "UIColor+YaleMobile.h"

#import "YMTheme.h"

@interface YMMainViewController ()

@end

@implementation YMMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [YMGlobalHelper setupUserDefaults];
  [YMGlobalHelper addMenuButtonToController:self];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
  
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
  [super viewWillAppear:animated];
  
  NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
  self.name = (name) ? [NSString stringWithFormat:@", %@", name] : @"";
  
  [YMGlobalHelper setupSlidingViewControllerForController:self];
  
  [YMGlobalHelper showNotificationInViewController:self.navigationController
                                           message:@"Loading..."
                                         tintColor:[YMTheme notificationTintColor]];
  
  [YMServerCommunicator getWeatherWithCompletionBlock:^(NSArray *weatherInfo) {
    [self.mainView configureWeatherSubviews:weatherInfo];
  }];
  
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  
}

- (void)menu:(id)sender
{
  [YMGlobalHelper setupMenuButtonForController:self];
}

@end
