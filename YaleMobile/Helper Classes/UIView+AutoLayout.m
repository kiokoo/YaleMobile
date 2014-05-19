//
//  Created by Danqing on 2/24/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "UIView+AutoLayout.h"

// Simply because it is just way too looooooooooooooooooooooooooooong.
#define NSLC NSLayoutConstraint

@implementation UIView (AutoLayout)

- (void)useAutoLayout
{
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}


# pragma mark - Pin to edge of super view.

- (void)pinToParentView:(UIView *)view withInsets:(ALInsets)insets
{
  if (insets.top != AL_SKIP)    [self pinTopToParentView:view    withInset:insets.top];
  if (insets.right != AL_SKIP)  [self pinRightToParentView:view  withInset:insets.right];
  if (insets.bottom != AL_SKIP) [self pinBottomToParentView:view withInset:insets.bottom];
  if (insets.left != AL_SKIP)   [self pinLeftToParentView:view   withInset:insets.left];
}

- (NSLC *)pinTopToParentView:(UIView *)view withInset:(CGFloat)inset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:inset];
  [view addConstraint:c];
  return c;
}

- (NSLC *)pinRightToParentView:(UIView *)view withInset:(CGFloat)inset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:-inset];
  [view addConstraint:c];
  return c;
}

- (NSLC *)pinBottomToParentView:(UIView *)view withInset:(CGFloat)inset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-inset];
  [view addConstraint:c];
  return c;
}

- (NSLC *)pinLeftToParentView:(UIView *)view withInset:(CGFloat)inset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:inset];
  [view addConstraint:c];
  return c;
}


# pragma mark - Set dimension.

- (void)setFixedSize:(CGSize)size
{
  [self setFixedWidth:size.width];
  [self setFixedHeight:size.height];
}


- (NSLC *)setFixedWidth:(CGFloat)width
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
  [self addConstraint:c];
  return c;
}


- (NSLayoutConstraint *)setFixedHeight:(CGFloat)height
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
  [self addConstraint:c];
  return c;
}


- (void)setMinimumSize:(CGSize)size
{
  [self setMinimumWidth:size.width];
  [self setMinimumHeight:size.height];
}


- (NSLC *)setMinimumWidth:(CGFloat)width
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
  [self addConstraint:c];
  return c;
}


- (NSLayoutConstraint *)setMinimumHeight:(CGFloat)height
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
  [self addConstraint:c];
  return c;
}


# pragma mark - Center view.

- (void)centerToParentView:(UIView *)view withOffsets:(ALOffsets)offsets
{
  [self centerXToParentView:view withOffset:offsets.x];
  [self centerYToParentView:view withOffset:offsets.y];
}


- (NSLC *)centerXToParentView:(UIView *)view withOffset:(CGFloat)offset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:offset];
  [view addConstraint:c];
  return c;
}


- (NSLC *)centerYToParentView:(UIView *)view withOffset:(CGFloat)offset
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:offset];
  [view addConstraint:c];
  return c;
}


# pragma mark - Relation to sibling views.

- (NSLC *)setAboveView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:-distance];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)setBelowView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:distance];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)setLeftOfView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-distance];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)setRightOfView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:distance];
  [parentView addConstraint:c];
  return c;
}


- (void)alignWithView:(UIView *)view withEdgeOffsets:(ALInsets)offsets inParentView:(UIView *)parentView
{
  if (offsets.top != AL_SKIP)    [self topAlignWithView:view withOffset:offsets.top inParentView:parentView];
  if (offsets.right != AL_SKIP)  [self rightAlignWithView:view withOffset:offsets.right inParentView:parentView];
  if (offsets.bottom != AL_SKIP) [self bottomAlignWithView:view withOffset:offsets.bottom inParentView:parentView];
  if (offsets.left != AL_SKIP)   [self leftAlignWithView:view withOffset:offsets.left inParentView:parentView];
}


- (NSLC *)leftAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:offset];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)rightAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:offset];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)topAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:offset];
  [parentView addConstraint:c];
  return c;
}


- (NSLC *)bottomAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView
{
  NSLC *c = [NSLC constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                              toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:offset];
  [parentView addConstraint:c];
  return c;
}

@end
