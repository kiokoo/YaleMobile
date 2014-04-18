//
//  YMSplashViewController.m
//  YaleMobile
//
//  Created by Danqing on 7/23/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMSplashViewController.h"

@interface YMSplashViewController ()

@end

@implementation YMSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *bg = ([[UIScreen mainScreen] bounds].size.height == 568) ? [UIImage imageNamed:@"Default-568h2.png"] : [UIImage imageNamed:@"Default2.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
