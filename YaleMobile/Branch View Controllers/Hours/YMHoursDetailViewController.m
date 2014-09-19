//
//  YMHoursDetailViewController.m
//  YaleMobile
//
//  Created by Danqing on 5/12/13.
//  Copyright (c) 2013 Danqing Liu. All rights reserved.
//

#import "YMHoursDetailViewController.h"
#import "YMSimpleCell.h"
#import "YMGlobalHelper.h"

#import "YMTheme.h"

@interface YMHoursDetailViewController ()

@end

@implementation YMHoursDetailViewController

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
  self.keys = [[self.data allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
  self.tableView.backgroundColor = [UIColor clearColor];
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

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSimpleCell *cell;
  if (indexPath.row == 0) {
    cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Detail Header"];
    NSString *text = [self.keys objectAtIndex:indexPath.section];
    /*
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18] constrainedToSize:CGSizeMake(268, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18] andConstraintSize:CGSizeMake(268, 5000)];
    CGRect frame = cell.name1.frame;
    frame.size.height = textSize.height;
    cell.name1.frame = frame;
    cell.name1.text = text;
  } else {
    cell = (YMSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"Hours Detail Cell"];
    NSString *text = [self.data objectForKey:[self.keys objectAtIndex:indexPath.section]];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"shadowbg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    cell.backgroundView.alpha = 0.6;
    
    /* deprecated
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] andConstraintSize:CGSizeMake(268, 5000)];
    CGRect frame = cell.name1.frame;
    frame.size.height = textSize.height;
    cell.name1.frame = frame;
    cell.name1.text = text;
  }
  
  cell.name1.textColor = [YMTheme gray];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
      return [YMTheme groupedTableTopLabelCellHeight];
  } else {
    NSString *text = [self.data objectForKey:[self.keys objectAtIndex:indexPath.section]];
    /* deprecated
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(268, 5000)];
     */
    CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] andConstraintSize:CGSizeMake(268, 5000)];
    return textSize.height + 43;
  }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
