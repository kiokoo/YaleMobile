//
//  YMSettingsModalViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/16/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMSettingsModalViewController.h"

@interface YMSettingsModalViewController ()

@end

@implementation YMSettingsModalViewController

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
    
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [confirm setBackgroundImage:[UIImage imageNamed:@"button_navbar_ok.png"] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:confirm]];
    [confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"button_navbar_cancel.png"] forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:cancel]];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
#warning TODO(hengchu): this may need to be removed.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.background1.image = [[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.background1.alpha = 0.6;
    
    self.textField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    if (name) self.textField1.text = name;
}

- (void)confirm:(id)sender
{
    if (self.textField1.text.length) {
        [[NSUserDefaults standardUserDefaults] setObject:self.textField1.text forKey:@"Name"];
    } else
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Name"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
