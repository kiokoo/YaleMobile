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
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"

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
    [YMGlobalHelper addBackButtonToController:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plaintabletop.png"]];
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
    NSLog(@"Remove with timestamp %f", interval);
    [Course removeCoursesBeforeTimestamp:interval inManagedObjectContext:self.db.managedObjectContext];
    [self setupFetchedResultsController];
    [self fetchData:self.db withTimestamp:interval];
}

- (void)fetchData:(UIManagedDocument *)document withTimestamp:(NSTimeInterval)timestamp
{
    NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *preParse = [doc searchWithXPathQuery:@"//td[@class]"];
    NSArray *preParse2 = [doc searchWithXPathQuery:@"//td[@class]/a"];
    
    __block NSUInteger count = 0;
    NSLog(@"Add with timestamp %f. Total %d", timestamp, preParse2.count);
    for (NSUInteger i = 0; i < preParse2.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7]).content forKey:@"subject"];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7+1]).content forKey:@"number"];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7+2]).content forKey:@"section"];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7+3]).content forKey:@"srn"];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7+5]).content forKey:@"instructor"];
        [dict setObject:((TFHppleElement *)[preParse objectAtIndex:i*7+6]).content forKey:@"happens"];
        
        self.term = [YMGlobalHelper getTerm];
        NSString *abbreviatedName = ((TFHppleElement *)[preParse2 objectAtIndex:i]).content;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://students.yale.edu/oci/resultDetail.jsp?course=%@&term=%@",[[((TFHppleElement *)[preParse objectAtIndex:3+7*i]).content stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""], self.term]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = operation.responseString;
            responseString = [responseString stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];

            if ([abbreviatedName isEqualToString:@"CANCELLED"]) [dict setObject:@"CANCELLED" forKey:@"name"];
            else {
                NSData *data2 = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple *doc2 = [[TFHpple alloc] initWithHTMLData:data2];
                NSArray *parse = [doc2 searchWithXPathQuery:@"//b"];
                
                [dict setObject:((TFHppleElement *)[parse objectAtIndex:0]).content forKey:@"name"];
            }
            [dict setObject:responseString forKey:@"data"];
            
            [document.managedObjectContext performBlock:^{
                [Course courseWithData:dict forTimestamp:timestamp inManagedObjectContext:document.managedObjectContext];
            }];
            if (count < preParse2.count - 1) count++;
            else {
                self.tableView.scrollEnabled = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail. %@", error);
        }];
        [operation start];
    }
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
    cell.name.shadowColor = [UIColor whiteColor];       cell.name.shadowOffset = CGSizeMake(0, 1);
    cell.code.shadowColor = [UIColor whiteColor];       cell.code.shadowOffset = CGSizeMake(0, 1);
    cell.happens.shadowColor = [UIColor whiteColor];    cell.happens.shadowOffset = CGSizeMake(0, 1);
    cell.instructor.shadowColor = [UIColor whiteColor]; cell.instructor.shadowOffset = CGSizeMake(0, 1);
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"plaintablebg_highlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)]];

    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.name.text = course.name;
    cell.happens.text = course.happens;
    cell.instructor.text = course.instructor;
    cell.code.text = course.code;
    
    CGSize textSize = [course.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 5000.0f)];
    CGRect newFrame = cell.name.frame;
    newFrame.size.height = textSize.height;
    cell.name.frame = newFrame;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];

    CGSize textSize = [course.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16] constrainedToSize:CGSizeMake(280, 5000.0f)];
    
    return MAX(74, textSize.height + 53.0);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"Bluebook Detail Segue" sender:self];
}

@end
