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
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plaintabletop.png"]];
  self.tableView.sectionIndexColor = [[YMTheme blue] colorWithAlphaComponent:0.7];
  
  if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
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
  cell.name1.shadowColor = [UIColor whiteColor];       cell.name1.shadowOffset = CGSizeMake(0, 1);
  cell.code1.shadowColor = [UIColor whiteColor];       cell.code1.shadowOffset = CGSizeMake(0, 1);
  cell.happens1.shadowColor = [UIColor whiteColor];    cell.happens1.shadowOffset = CGSizeMake(0, 1);
  cell.instructor1.shadowColor = [UIColor whiteColor]; cell.instructor1.shadowOffset = CGSizeMake(0, 1);
  cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)]];
  cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)]];
  
  Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.name1.text = course.name;
  cell.happens1.text = course.happens;
  cell.instructor1.text = course.instructor;
  cell.code1.text = course.code;
  /* deprecated code
  CGSize textSize = [course.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 5000.0f)];
   */
  CGSize textSize = [YMGlobalHelper boundText:course.name withFont:[UIFont fontWithName:@"HelveticaNeue" size:16] andConstraintSize:CGSizeMake(280, 5000.0f)];
  CGRect newFrame = cell.name1.frame;
  newFrame.size.height = textSize.height;
  cell.name1.frame = newFrame;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  /*
  CGSize textSize = [course.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 5000.0f)];
   */
  CGSize textSize = [YMGlobalHelper boundText:course.name withFont:[UIFont fontWithName:@"HelveticaNeue" size:16] andConstraintSize:CGSizeMake(280, 5000.0f)];
  
  return MAX(74, textSize.height + 53.0);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.selectedIndexPath = indexPath;
  [self performSegueWithIdentifier:@"Bluebook Detail Segue" sender:self];
}

@end
