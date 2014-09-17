//
//  YMBluebookSubjectViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMBluebookSubjectViewController.h"
#import "YMBluebookDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMDatabaseHelper.h"
#import "Course+OCI.h"
#import "YMBluebookSubjectCell.h"
#import "YMBluebookSubjectViewController+YMBluebookSubjectViewData.h"
#import "YMTheme.h"
#import <PureLayout/PureLayout.h>

@interface YMBluebookSubjectViewController ()

@end

@implementation YMBluebookSubjectViewController

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
  self.tableView.sectionIndexColor = [[YMTheme blue] colorWithAlphaComponent:0.7];
  
  if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
  }
  
  [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, -15, 0, 0)];
  
  self.tableView.separatorColor = [YMTheme separatorGray];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  
  // Gets rid of extra separator for ya :)
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (self.selectedIndexPath) {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = nil;
  }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  YMBluebookDetailViewController *bdvc = (YMBluebookDetailViewController *)segue.destinationViewController;
  bdvc.course = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
  [bdvc parseData];
}

- (void)useDocument
{
  if ((self.db = [YMDatabaseHelper getManagedDocument]))
    [self loadData];
  else {
    [YMDatabaseHelper openDatabase:@"database" usingBlock:^(UIManagedDocument *document) {
      self.db = document;
      [YMDatabaseHelper setManagedDocumentTo:document];
      [self loadData];
    }];
  }
}

- (void)loadData
{
  NSTimeInterval interval = [YMGlobalHelper getTimestamp];
  DLog(@"Remove with timestamp %f", interval);
  [Course removeCoursesBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
  [self setupFetchedResultsController];
  [self fetchData:self.db withTimestamp:interval];
}


- (void)setupFetchedResultsController
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
  NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
  NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES];
  request.sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.db.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMBluebookSubjectCell *cell = (YMBluebookSubjectCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Subject Cell"];

  cell.code1.textColor                  = [YMTheme bluebookSubjectCodeTextColor];
  cell.code1.highlightedTextColor       = cell.code1.textColor;
  
  cell.happens1.textColor               = [YMTheme laundryTimeAndBluebookHappensTextColor];
  cell.happens1.highlightedTextColor    = cell.happens1.textColor;
  
  cell.instructor1.textColor            = [YMTheme lightGray];
  cell.instructor1.highlightedTextColor = cell.instructor1.textColor;
  
  cell.name1.textColor                  = [YMTheme gray];
  cell.name1.highlightedTextColor       = cell.name1.textColor;
  
  Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.name1.text = course.name;
  cell.happens1.text = course.happens;
  cell.instructor1.text = course.instructor;
  cell.code1.text = course.code;

  CGSize textSize = [YMGlobalHelper boundText:course.name withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16] andConstraintSize:CGSizeMake(280, 5000.0f)];
  CGRect newFrame = cell.name1.frame;
  newFrame.size.height = textSize.height;
  cell.name1.frame = newFrame;
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
                                                forCell:cell];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  /*
  CGSize textSize = [course.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 5000.0f)];
   */
  CGSize textSize = [YMGlobalHelper boundText:course.name withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16] andConstraintSize:CGSizeMake(280, 5000.0f)];
  
  return MAX(74, textSize.height + 53.0);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedIndexPath = indexPath;
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self performSegueWithIdentifier:@"Bluebook Detail Segue" sender:self];
}

@end
