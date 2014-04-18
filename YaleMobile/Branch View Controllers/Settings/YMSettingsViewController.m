//
//  YMSettingsViewController.m
//  YaleMobile
//
//  Created by iBlue on 12/27/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMSettingsViewController.h"
#import "ECSlidingViewController.h"
#import "YMGlobalHelper.h"
#import "YMSettingsDetailViewController.h"
#import "YMServerCommunicator.h"

@interface YMSettingsViewController ()

@end

@implementation YMSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YMGlobalHelper addMenuButtonToController:self];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    
    self.settings = @[@"My Name", @"Weather Unit"];
    self.abouts = @[@"About Yale Mobile", @"Credits", @"Contact Developer", @"Write a Review"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [YMServerCommunicator cancelAllHTTPRequests];
    [YMGlobalHelper setupSlidingViewControllerForController:self];
    if (self.selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.selectedIndexPath = nil;
    }
}

- (void)menu:(id)sender
{
    [YMGlobalHelper setupMenuButtonForController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) return YES;
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Settings Segue"]) {
        YMSettingsDetailViewController *sdvc = (YMSettingsDetailViewController *)[segue destinationViewController];
        sdvc.isAbout = self.isAbout;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createActionSheetForWeather
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Choose temperature unit"] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Celsius", @"Fahrenheit", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Celsius"])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Celsius"];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Celsius"];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return self.settings.count;
    else return self.abouts.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YMSubtitleCell *cell;
        if (indexPath.row == 0) {
            cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Subtitle Cell 1"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.secondary.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]) ? [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"] : @"Not set";
        } else if (indexPath.row == self.settings.count - 1) {
            cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Subtitle Cell 2"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.secondary.text = [[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"] ? @"Celsius" : @"Fahrenheit";
        } else {
            cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Subtitle Cell 2"];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
        cell.primary.text = [self.settings objectAtIndex:indexPath.row];
        cell.backgroundView.alpha = 0.6;
        return cell;
    } else {
        YMSimpleCell *cell;
        if (indexPath.row == 0) {
            cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Header"];
            cell.name.text = @"Information";
        } else if (indexPath.row == 1) {
            cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Simple Cell 1"];
            cell.name.text = [self.abouts objectAtIndex:indexPath.row - 1];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_top_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 5, 20)]];
        } else if (indexPath.row == self.abouts.count) {
            cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Setting Simple Cell 2"];
            cell.name.text = [self.abouts objectAtIndex:indexPath.row - 1];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_bottom_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        } else if (indexPath.row == self.abouts.count + 1) {
            cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Footer"];
            cell.name.text = @"Copyright © Danqing 2013. 718529.";
        } else {
            cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Setting Simple Cell 2"];
            cell.name.text = [self.abouts objectAtIndex:indexPath.row - 1];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tablebg_mid_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 10, 20)]];
        }
        cell.backgroundView.alpha = 0.6;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0)
        return 38;
    else if ((indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == self.settings.count - 1)) || (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == self.abouts.count)))
        return 54;
    else if (indexPath.section == 1 && indexPath.row == self.abouts.count + 1)
        return 50;
    else
        return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"Settings Name Segue" sender:self];
        } else {
            [self createActionSheetForWeather];
        }
    } else {
        if (indexPath.row == 1) {
            self.isAbout = YES;
            [self performSegueWithIdentifier:@"Settings Segue" sender:self];
        } else if (indexPath.row == 2) {
            self.isAbout = NO;
            [self performSegueWithIdentifier:@"Settings Segue" sender:self];
        } else if (indexPath.row == 3) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                NSArray *toRecipients = [NSArray arrayWithObjects:@"yale.mobile.app@gmail.com", nil];
                [mailer setToRecipients:toRecipients];
                [[mailer navigationBar] setTintColor:[UIColor colorWithRed:63/255.0 green:155/255.0 blue:194/255.0 alpha:0.1]];
                [self presentViewController:mailer animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"YaleMobile is unable to launch the email service. Your device doesn't support the composer sheet."
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/app/yalemobile/id497588523?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

@end
