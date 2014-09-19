//
//  YMSettingsDetailViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/13/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMSettingsDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMSimpleCell.h"

#import "YMTheme.h"

@interface YMSettingsDetailViewController ()

@end

@implementation YMSettingsDetailViewController

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
  self.title = (self.isAbout) ? @"About" : @"Credits";
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
  self.tableView.allowsSelection = NO;
  
  self.aboutHeader = @[@"App Version", @"About Yale Mobile"];
  self.aboutArray = @[@"2.9 (3A925)", @"Yale Mobile is an application designed to improve the mobile computing experience of the Yale community. Yale University does not officially endorse this application. If you have any comments or suggestions, we would be more than happy to hear them.\n\nYale Mobile does not collect user data in any way. Your privacy is our top consideration. All information presented in this application is publicly accessible. If you feel uncomfortable about any information, you can contact Yale University (or other sources) to remove it.\n\nYale Mobile started as a personal project of Danqing Liu (CC '13) in 2012, and is now maintained by Hengchu Zhang (CC '15) and other student developers. If you want to participate in making the future version of the app, please also let us know!\n\nYale Mobile is an open source application under MIT license. You can find its source code at github.com/kiokoo/yalemobile."];
  self.creditHeader = @[@"Version 2.9", @"Version 2", @"Version 1"];
  self.creditArray = @[@"Version 2.9 of Yale Mobile is developed by Hengchu Zhang (CC '15) and designed by Danqing Liu (CC '13) with love in 2014 for fellow Yalies. Jenny Allen (TC '16) and Charly Walther (BK '16) contributed during the development of this release. We would like to thank everyone who sent us feedback during the past year, and to thank President Salovey for the support in making this application.\n\nAs both developers of the app are Hounies, Yale Mobile 2.9 is dedicated to Leslie Woodard, the beloved Dean of Calhoun College who passed away in October 2013.", @"The developer would like to express his sincere gratitude to Jing Han (YSOA '14) for various design contributions and suggestions, Christina Chi Zhang (SY '17) for the amazing launching image, Edwin Bebyn (Manager, Yale Transit) for enabling TransLoc integration, Adam Bray (Asst. Mgr. STC, ITS) for the support through Student Developer Program, Hengchu Zhang for enabling Yale Dining menu integration, and Scarlett Zuo (PC '16) for the list of building codes and for simply being there with him.\n\nThe photo of Branford College was taken by Yingqi Tan (PC '14), Davenport College, by Jian Li (DC '12), Hall of Graduate Studies, Jonathan Edwards College, Saybrook College, Ezra Stiles College, and Trumbull College, by Hengchu Zhang, Pierson College, by Scarlett Zuo, Silliman College, by Yinshuo Zhang (SM '16), Timothy Dwight College, by Linda Lai (TD '13). The developer would like to thank them for their great contributions, without which the application could not have been how it looks now. The developer would also like to thank Xiaoyue Yin (JE '15) and Xiao Wu (TD '16), who also provided great photos.\n\nThis application uses AFNetworking and MBProgressHUD libraries, under their respective licenses, and has content from Yale Dining Fast Track, Yale Phonebook, TransLoc, Yale Library System, LaundryView, and Yale OCI. All information presented in this application is publicly accessible.\n\nThis application is designed and developed with love by Danqing Liu in New Haven, CT in 2013 for fellow Yalies.", @"The developer would like to thank Yingqi Tan and Jian Li for providing the dining hall photos, Bryan Ford (Professor, Dept. of Computer Science) and Sherwin Yu (MC '12) for the help during the development of this application, and Sijia Song (DC '14) and Simon Song (CC '14) for the feedback during the testing stage.\n\nThis application uses ASIHTTPRequest and Hpple libraries, and has content from Yale Dining Fast Track, Yale Phonebook, LaundryView, and Yale OCI. All information presented in this application is publicly accessible.\n\nThis application is designed and developed with love by Danqing Liu in New Haven, CT in 2012 for fellow Yalies."];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  UIView *cell = [gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
  if (fabsf(translation.x) > fabsf(translation.y)) return YES;
  return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.isAbout ? 2 : 3;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Header"];
    cell.name1.text = (self.isAbout) ? [self.aboutHeader objectAtIndex:indexPath.section] : [self.creditHeader objectAtIndex:indexPath.section];
    cell.name1.textColor = [YMTheme gray];
    return cell;
  } else {
    YMSimpleCell *cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Settings Detail Cell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    cell.backgroundView.alpha = 0.6;
    
    NSString *text = (self.isAbout) ? [self.aboutArray objectAtIndex:indexPath.section] : [self.creditArray objectAtIndex:indexPath.section];
    /* deprecated code
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] andConstraintSize:CGSizeMake(268, 5000)];
    CGRect frame = cell.name1.frame;
    frame.size.height = textSize.height;
    cell.name1.frame = frame;
    cell.name1.text = text;
    cell.name1.textColor = [YMTheme gray];
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
    return [YMTheme groupedTableTopLabelCellHeight];
  else {
    NSString *text = (self.isAbout) ? [self.aboutArray objectAtIndex:indexPath.section] : [self.creditArray objectAtIndex:indexPath.section];
    /* deprecated code
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] andConstraintSize:CGSizeMake(268, 5000)];
    return textSize.height + 42;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

@end
