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
  
  UIImage *bg = nil;

  CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
  
  if (screenHeight < 568) {
    bg = [UIImage imageNamed:@"4s"];
  } else if (screenHeight == 568) {
    bg = [UIImage imageNamed:@"5"];
  } else if (screenHeight == 667) {
    bg = [UIImage imageNamed:@"6"];
  } else {
    bg = [UIImage imageNamed:@"6+"];
  }

  self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
