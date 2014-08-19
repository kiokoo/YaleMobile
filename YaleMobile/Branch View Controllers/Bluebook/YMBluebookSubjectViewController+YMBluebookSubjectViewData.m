//
//  YMBluebookSubjectViewController+YMBluebookSubjectViewData.m
//  YaleMobile
//
//  Created by Hengchu Zhang on 7/14/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "YMBluebookSubjectViewController+YMBluebookSubjectViewData.h"

#import "TFHpple.h"
#import "TFHppleElement.h"
#import "AFHTTPRequestOperation.h"
#import "YMGlobalHelper.h"
#import "Course+OCI.h"
#import "YMAppDelegate.h"

static NSString *OCICourseURL = @"http://students.yale.edu/oci/resultDetail.jsp?course=%@&term=%@";

@implementation YMBluebookSubjectViewController (YMBluebookSubjectViewData)

- (void)fetchData:(UIManagedDocument *)document withTimestamp:(NSTimeInterval)timestamp
{
  NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];
  TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
  NSArray *preParse = [doc searchWithXPathQuery:@"//td[@class]"];
  NSArray *preParse2 = [doc searchWithXPathQuery:@"//td[@class]/a"];
  
  __block NSUInteger count = 0;
  DLog(@"Add with timestamp %f. Total %lu", timestamp, (unsigned long)preParse2.count);
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:OCICourseURL,[[((TFHppleElement *)[preParse objectAtIndex:3+7*i]).content stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""], self.term]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSString *responseString = operation.responseString;
      responseString = [responseString stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
      responseString = [responseString stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
      responseString = [responseString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
      responseString = [responseString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
      
      if ([abbreviatedName isEqualToString:@"CANCELLED"]) {
        [dict setObject:@"CANCELLED" forKey:@"name"];
      } else {
        NSData *data2 = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *doc2 = [[TFHpple alloc] initWithHTMLData:data2];
        NSArray *parse = [doc2 searchWithXPathQuery:@"//b"];
        
        [dict setObject:((TFHppleElement *)[parse objectAtIndex:0]).content forKey:@"name"];
      }
      [dict setObject:responseString forKey:@"data"];
      
      [document.managedObjectContext performBlock:^{
        [Course courseWithData:dict forTimestamp:timestamp inManagedObjectContext:document.managedObjectContext];
      }];
      if (count < preParse2.count - 1) {
        count++;
      } else {
        self.tableView.scrollEnabled = YES;
        [YMGlobalHelper hideNotificationView];
      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      DLog(@"Fail. %@", error);
    }];
    [operation start];
  }
}

@end
