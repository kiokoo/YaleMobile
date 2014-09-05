//
//  YMBluebookDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMBluebookDetailViewController.h"
#import "YMGlobalHelper.h"
#import "UIColor+YaleMobile.h"
#import "YMSubtitleCell.h"
#import "Course.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "UIImage+Emboss.h"
#import "YMTheme.h"

@interface YMBluebookDetailViewController ()

@end

@implementation YMBluebookDetailViewController

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
  self.tableView.separatorInset = UIEdgeInsetsZero;
  self.tableView.separatorColor = [YMTheme separatorGray];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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

- (void)parseData
{
  NSString *rawData = self.course.data;
  
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"</P>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<table BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"5\" WIDTH=\"100%\" BGCOLOR=\"#FFFFFF\">" withString:@"<table id=\"specialclass\">"];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<tbody>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"</tbody>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<tr>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"</tr>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<span>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
  
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<p style=\"margin: 0.0px 0.0px 0.0px 0.0px; font: 10.0px Verdana\"><font face=\"Tahoma\" size=\"3\"><span style=\"font-size: 12px;\">" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"</span></font>" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"following" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@":" withString:@""];
  rawData = [rawData stringByReplacingOccurrencesOfString:@"<table width=\"100%\" border=\"0\" cellspacing=\"2\" cellpadding=\"0\">" withString:@"<table id=\"infoclass\">"];
  
  NSData *data = [rawData dataUsingEncoding:NSUTF8StringEncoding];
  TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
  NSArray *parse = [doc searchWithXPathQuery:@"//table[@id='specialclass']/td[@class='RowText']"];
  NSArray *parse2 = [doc searchWithXPathQuery:@"//table[@id='infoclass']/td[@class='RowText']"];
  
  self.data = [[NSMutableDictionary alloc] init];
  
  [self.data setObject:self.course.section forKey:@"dSection"];
  [self.data setObject:[[self.course.srn stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] forKey:@"aSRN"];
  [self.data setObject:self.course.instructor forKey:@"bInstructors"];
  [self.data setObject:self.course.happens forKey:@"cTime & Location"];
  
  if (parse.count) {
    NSString *detail = ((TFHppleElement *)[parse objectAtIndex:0]).content;
    if (detail.length)
      [self.data setObject:((TFHppleElement *)[parse objectAtIndex:0]).content forKey:@"jDetail"];
  }
  
  if (parse.count > 1) {
    NSString *note = ((TFHppleElement *)[parse objectAtIndex:1]).content;
    if (note.length) {
      NSString *noteString = ((TFHppleElement *)[parse objectAtIndex:1]).content;
      noteString = [noteString stringByReplacingOccurrencesOfString:@"preregister for the spring term at" withString:@""];
      [self.data setObject:((TFHppleElement *)[parse objectAtIndex:1]).content forKey:@"kNotes"];
    }
  }
  
  if (parse2.count) {
    for (NSUInteger i = 0; i < parse2.count; i++) {
      NSString *text = ((TFHppleElement *)[parse2 objectAtIndex:i]).content;
      if ([text rangeOfString:@"Areas"].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@"Areas " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.data setObject:text forKey:@"eAreas"];
      }
      if ([text rangeOfString:@"Skill"].location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@"Skills " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.data setObject:text forKey:@"fSkills"];
      }
      if ([text rangeOfString:@"exam"].location != NSNotFound) {
        [self.data setObject:text forKey:@"gExam"];
      }
      if ([text rangeOfString:@"reading period"].location != NSNotFound) {
        [self.data setObject:text forKey:@"hReading Period"];
      }
      if ([text rangeOfString:@"Department Pre-Approval"].location != NSNotFound) {
        [self.data setObject:text forKey:@"1Pre-Approval"];
      }
      if ([text rangeOfString:@"/"].location != NSNotFound && [text rangeOfString:self.course.srn].location != NSNotFound) {
        NSString *tempString = text;
        
        tempString = [tempString stringByReplacingOccurrencesOfString:self.course.srn withString:@""];
        tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSRange range;
        
        range.location = 0;
        range.length = 7;
        tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
        
        // MAY NOT NEED BELOW ----------------
        /*
         if ([tempString hasPrefix:@"1"]) {
         range.length = 2;
         tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
         }
         if ([tempString hasPrefix:@"/"]) {
         range.length = 1;
         tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
         }
         if ([tempString hasPrefix:@"01"]) {
         range.length = 4;
         tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
         }
         if ([self.course.code hasPrefix:@"LAW"]) {
         range.length = 5;
         tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
         }
         */
        // MAY NOT NEED ABOVE ----------------
        
        NSMutableArray *alphabetArray = [NSMutableArray arrayWithCapacity:26];
        for (char a = 'A'; a < 'Z'; a++) {
          [alphabetArray addObject:[NSString stringWithFormat:@"%c", a]];
        }
        
        // Here's the function that does the equivalent of what happens in the while loop before
        BOOL (^checkPrefix)(NSString *str) = ^(NSString *str) {
          BOOL result = NO;
          for (NSString *a in alphabetArray) {
            result = result || [str hasPrefix:a];
            // we can terminate as soon as it's true
            if (result) return result;
          }
          return result;
        };
        
        while (!checkPrefix(tempString)) {
          range.length = 1;
          tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
        }
        
        [self.data setObject:tempString forKey:@"0Cross List"];
      }
    }
  }
  [self updateTableHeader];
}

- (void)updateTableHeader
{
  UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 28)];
  NSString *string   = self.course.code;
  UIFont *font       = [UIFont systemFontOfSize:15];
  CGSize textSize    = [YMGlobalHelper boundText:string
                                        withFont:font
                               andConstraintSize:CGSizeMake(280, 5000)];
  
  CGRect newFrame         = titleView.frame;
  newFrame.size.height    = textSize.height;
  titleView.frame         = newFrame;
  titleView.text          = string;
  titleView.font          = font;
  titleView.numberOfLines = 0;
  titleView.textColor     = [UIColor YMBluebookBlue];
  
  UILabel *subtitleView      = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + titleView.frame.size.height, 280, 30)];
  subtitleView.numberOfLines = 0;
  NSString *subtitleString   = self.course.name;
  UIFont *subtitleFont       = [UIFont systemFontOfSize:18];
  CGSize subTextSize         = [YMGlobalHelper
                        boundText:subtitleString
                        withFont:subtitleFont
                        andConstraintSize:CGSizeMake(280, 5000)];
  
  CGRect newSubFrame      = subtitleView.frame;
  newSubFrame.size.height = subTextSize.height;
  subtitleView.frame      = newSubFrame;
  subtitleView.text       = subtitleString;
  subtitleView.font       = subtitleFont;
  subtitleView.textColor  = [UIColor colorWithRed:111/255.0 green:132/255.0
                                             blue:132/255.0 alpha:0.8];
  
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, titleView.frame.size.height + subtitleView.frame.size.height + 75)];
  
  UIView* attributeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 30 + titleView.frame.size.height + subtitleView.frame.size.height, 320.0, 45.0)];
  
#warning TODO(HC) Replace this with a backgroundView method.
  attributeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bbdetailbanner.png"]];
  
  NSString *areas = [self.data objectForKey:@"eAreas"];
  NSString *skills = [self.data objectForKey:@"fSkills"];
  if (areas.length == 0) areas = @"0";
  if (skills.length == 0) skills = @"0";
  
  if ([areas rangeOfString:@"Hu"].location != NSNotFound) {
    UIImageView *hu = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 25)];
    hu.image = [UIImage imageNamed:@"icon_hu.png"];
    [attributeView addSubview:hu];
  }
  
  if ([areas rangeOfString:@"So"].location != NSNotFound) {
    UIImageView *so = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 25, 25)];
    so.image = [UIImage imageNamed:@"icon_so.png"];
    [attributeView addSubview:so];
  }
  
  if ([areas rangeOfString:@"Sc"].location != NSNotFound) {
    UIImageView *sc = [[UIImageView alloc] initWithFrame:CGRectMake(90, 10, 25, 25)];
    sc.image = [UIImage imageNamed:@"icon_sc.png"];
    [attributeView addSubview:sc];
  }
  
  if ([skills rangeOfString:@"QR"].location != NSNotFound) {
    UIImageView *qr = [[UIImageView alloc] initWithFrame:CGRectMake(205, 10, 25, 25)];
    qr.image = [UIImage imageNamed:@"icon_qr.png"];
    [attributeView addSubview:qr];
  }
  
  if ([skills rangeOfString:@"WR"].location != NSNotFound) {
    UIImageView *wr = [[UIImageView alloc] initWithFrame:CGRectMake(240, 10, 25, 25)];
    wr.image = [UIImage imageNamed:@"icon_wr.png"];
    [attributeView addSubview:wr];
  }
  
  if ([skills rangeOfString:@"[WR]"].location != NSNotFound) {
    UIImageView *wr = [[UIImageView alloc] initWithFrame:CGRectMake(240, 10, 25, 25)];
    wr.image = [UIImage imageNamed:@"icon_xwr.png"];
    [attributeView addSubview:wr];
  }
  
  if ([skills rangeOfString:@"L"].location != NSNotFound) {
    UIImageView *ln = [[UIImageView alloc] initWithFrame:CGRectMake(275, 10, 25, 25)];
    
    if ([skills rangeOfString:@"L1"].location != NSNotFound)
      ln.image = [UIImage imageNamed:@"icon_l1.png"];
    
    if ([skills rangeOfString:@"L2"].location != NSNotFound)
      ln.image = [UIImage imageNamed:@"icon_l2.png"];
    
    if ([skills rangeOfString:@"L3"].location != NSNotFound)
      ln.image = [UIImage imageNamed:@"icon_l3.png"];
    
    if ([skills rangeOfString:@"L4"].location != NSNotFound)
      ln.image = [UIImage imageNamed:@"icon_l4.png"];
    
    if ([skills rangeOfString:@"L5"].location != NSNotFound)
      ln.image = [UIImage imageNamed:@"icon_l5.png"];
    
    [attributeView addSubview:ln];
  }
  
  [self.data removeObjectForKey:@"eAreas"];
  [self.data removeObjectForKey:@"fSkills"];
  
  [containerView addSubview:titleView];
  [containerView addSubview:subtitleView];
  [containerView addSubview:attributeView];
  self.tableView.tableHeaderView = containerView;
  
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  YMSubtitleCell *cell = (YMSubtitleCell *)[tableView dequeueReusableCellWithIdentifier:@"Bluebook Detail Cell"];
  
  NSArray *keys = [[self.data allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSString *index = [keys objectAtIndex:indexPath.row];
  
  NSString *text = [self.data objectForKey:index];
  cell.primary1.text = text;

  CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] andConstraintSize:CGSizeMake(280.0f, 5000.0f)];
  CGRect frame = cell.primary1.frame;
  frame.size.height = textSize.height;
  cell.primary1.frame = frame;
  
  NSRange range;
  range.location = 0;
  range.length = 1;
  index = [index stringByReplacingCharactersInRange:range withString:@""];
  
  cell.secondary1.text = index;
  
  cell.secondary1.textColor = [YMTheme lightGray];
  cell.primary1.textColor   = [YMTheme gray];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSArray *keys = [[self.data allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSString *text = [self.data objectForKey:[keys objectAtIndex:indexPath.row]];

  CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] andConstraintSize:CGSizeMake(280.0f, 5000.0f)];
  return textSize.height + 35;
}

@end
