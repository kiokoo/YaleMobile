//
//  YMBluebookDetailViewController.m
//  YaleMobile
//
//  Created by iBlue on 9/24/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

#import "YMBluebookDetailViewController.h"
#import "YMGlobalHelper.h"
#import "YMSubtitleCell.h"
#import "Course.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "UIImage+Emboss.h"
#import "YMTheme.h"
#import "YMLeftAlignedCollectionViewFlowLayout.h"

#import <PureLayout/PureLayout.h>

@interface YMBluebookDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *attributeCollectionView;
@property (nonatomic, strong) NSMutableArray   *attributeArray;
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
  
  DLog(@"RAW: %@", rawData);
  
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
  
  DLog(@"RAW: %@", rawData);
  
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
      // Make sure text is not nil.
      text = ([text length] == 0) ? (@"") : text;
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
        for (char a = 'A'; a <= 'Z'; a++) {
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
  titleView.textColor     = [YMTheme bluebookSubjectCodeTextColor];
  
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
  subtitleView.textColor  = [YMTheme gray];
  
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, titleView.frame.size.height + subtitleView.frame.size.height + 85)];

  self.attributeArray = [NSMutableArray array];
  
  NSString *areas = [self.data objectForKey:@"eAreas"];
  NSString *skills = [self.data objectForKey:@"fSkills"];
  
  if (areas && [areas rangeOfString:@"Hu"].location != NSNotFound) {
    [self.attributeArray addObject:@"Humanities"];
  }
  
  if (areas && [areas rangeOfString:@"So"].location != NSNotFound) {
    [self.attributeArray addObject:@"Social Science"];
  }
  
  if (areas && [areas rangeOfString:@"Sc"].location != NSNotFound) {
    [self.attributeArray addObject:@"Science"];
  }
  
  if (skills && [skills rangeOfString:@"QR"].location != NSNotFound) {
    [self.attributeArray addObject:@"Quantitative Reasoning"];
  }
  
  if (skills && [skills rangeOfString:@"WR"].location != NSNotFound) {
    [self.attributeArray addObject:@"Writing"];
  }
  
  if (skills && [skills rangeOfString:@"[WR]"].location != NSNotFound) {
    [self.attributeArray removeObject:@"Writing"];
    [self.attributeArray addObject:@"Optional Writing"];
  }
  
  if (skills && [skills rangeOfString:@"L"].location != NSNotFound) {
    
    if (skills && [skills rangeOfString:@"L1"].location != NSNotFound)
      [self.attributeArray addObject:@"Level 1"];
      
    if (skills && [skills rangeOfString:@"L2"].location != NSNotFound)
      [self.attributeArray addObject:@"Level 2"];
    
    if (skills && [skills rangeOfString:@"L3"].location != NSNotFound)
      [self.attributeArray addObject:@"Level 3"];
    
    if (skills && [skills rangeOfString:@"L4"].location != NSNotFound)
      [self.attributeArray addObject:@"Level 4"];
    
    if (skills && [skills rangeOfString:@"L5"].location != NSNotFound)
      [self.attributeArray addObject:@"Level 5"];
    
  }
  
  [self.data removeObjectForKey:@"eAreas"];
  [self.data removeObjectForKey:@"fSkills"];
  
  YMLeftAlignedCollectionViewFlowLayout *layout = [[YMLeftAlignedCollectionViewFlowLayout alloc] init];
  
  layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
  layout.minimumInteritemSpacing = 3.0f;
  layout.minimumLineSpacing      = 6.0f;
  
  self.attributeCollectionView = [[UICollectionView alloc]
                                  initWithFrame:CGRectMake(20, 40 + titleView.frame.size.height +
                                                           subtitleView.frame.size.height,
                                                           320.0, 45.0) collectionViewLayout:layout];
  
  self.attributeCollectionView.backgroundColor = [UIColor clearColor];
  self.attributeCollectionView.dataSource      = self;
  self.attributeCollectionView.delegate        = self;
  
  [self.attributeCollectionView registerClass:[UICollectionViewCell class]
                   forCellWithReuseIdentifier:@"AttributeCell"];
  
  
  [containerView addSubview:titleView];
  [containerView addSubview:subtitleView];

  [containerView addSubview:self.attributeCollectionView];

  CGRect collectionViewFrame         = self.attributeCollectionView.frame;
  CGFloat diff                       = collectionViewFrame.size.height - layout.collectionViewContentSize.height;
  collectionViewFrame.size.height   -= diff;
  self.attributeCollectionView.frame = collectionViewFrame;
  
  CGRect containerViewFrame       = containerView.frame;
  containerViewFrame.size.height -= diff - 10;
  containerView.frame             = containerViewFrame;
  
  UIView *hairLineTop         = [UIView newAutoLayoutView];
  [containerView addSubview:hairLineTop];
  hairLineTop.backgroundColor = [YMTheme separatorGray];
  [hairLineTop autoSetDimensionsToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 0.5f)];
  [hairLineTop autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
  [hairLineTop autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [hairLineTop autoConstrainAttribute:ALEdgeTop
                          toAttribute:ALEdgeTop
                               ofView:self.attributeCollectionView
                           withOffset:-10.0f];
  
  UIView *hairLineBot         = [UIView newAutoLayoutView];
  [containerView addSubview:hairLineBot];
  hairLineBot.backgroundColor = [YMTheme separatorGray];
  [hairLineBot autoSetDimensionsToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 0.5f)];
  [hairLineBot autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
  [hairLineBot autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
  [hairLineBot autoConstrainAttribute:ALEdgeBottom
                          toAttribute:ALEdgeBottom
                               ofView:self.attributeCollectionView
                           withOffset:10.0f];
  
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
  
  [YMGlobalHelper setupHighlightBackgroundViewWithColor:[YMTheme cellHighlightBackgroundViewColor]
                                                forCell:cell];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSArray *keys = [[self.data allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSString *text = [self.data objectForKey:[keys objectAtIndex:indexPath.row]];

  CGSize textSize = [YMGlobalHelper boundText:text withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] andConstraintSize:CGSizeMake(280.0f, 5000.0f)];
  return textSize.height + 35;
}

- (UIColor *)colorForClassAttribute:(NSString *)attr
{
  if ([attr isEqualToString:@"Social Science"]) {
    return [YMTheme socialScienceColor];
  } else if ([attr isEqualToString:@"Science"]) {
    return [YMTheme scienceColor];
  } else if ([attr isEqualToString:@"Quantitative Reasoning"]) {
    return [YMTheme quantitativeReasoningrColor];
  } else if ([attr isEqualToString:@"Humanities"]) {
    return [YMTheme humanitiesColor];
  } else if ([attr isEqualToString:@"Writing"]) {
    return [YMTheme writingColor];
  } else if ([attr isEqualToString:@"Optional Writing"]) {
    return [YMTheme writingColor];
  } else if ([attr hasPrefix:@"Level"]) {
    return [YMTheme languageColor];
  } else {
    ALog(@"Impossible!");
    return 0;
  }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *content = (self.attributeArray.count > 0)
                          ? [self.attributeArray objectAtIndex:indexPath.row]
                          : @"Not a distributional credit";
  
  CGRect size = [content boundingRectWithSize:CGSizeMake(99999.0f, 25.0f)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]}
                                      context:nil];
  CGSize rectSize  = size.size;
  if (![content isEqualToString:@"Not a distributional credit"]) {
    rectSize.width  += 12;
  }
  rectSize.height += 4;
  return rectSize;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return (self.attributeArray.count > 0) ? self.attributeArray.count : 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  UILabel *label;
  
  for (UIView *subview in [cell.contentView subviews]) {
    if ([subview isKindOfClass:[UILabel class]]) {
      label = (UILabel *)subview;
    }
    break;
  }
  
  if ([label.text isEqualToString:@"Not a distributional credit"]) {
    label.textColor = [YMTheme lightGray];
    cell.backgroundColor = [UIColor clearColor];
    return;
  }
  
  cell.backgroundColor = [self colorForClassAttribute:label.text];
  
  if ([label.text isEqualToString:@"Optional Writing"]) {
    label.textColor        = cell.backgroundColor;
    cell.layer.borderColor = cell.backgroundColor.CGColor;
    cell.backgroundColor   = [UIColor whiteColor];
    cell.layer.borderWidth = 0.5f;
  } else {
    label.textColor      = [UIColor whiteColor];
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeCell"
                                                                         forIndexPath:indexPath];
  UILabel *label = [UILabel new];
  label.text     = (self.attributeArray.count > 0) ? self.attributeArray[indexPath.row] : @"Not a distributional credit";
  label.font     = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
  label.backgroundColor = [UIColor clearColor];
  
  CGRect size = [label.text boundingRectWithSize:CGSizeMake(99999.0f, 25.0f)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:label.font}
                                         context:nil];
  
  CGFloat xOffset = ([label.text isEqualToString:@"Not a distributional credit"]) ? 0 : 6;
  label.frame = CGRectMake(xOffset, 2, CGRectGetWidth(size), ceil(CGRectGetHeight(size)));
  [cell.contentView addSubview:label];
  
  cell.layer.cornerRadius = 4.0f;
  
  return cell;
}

@end
