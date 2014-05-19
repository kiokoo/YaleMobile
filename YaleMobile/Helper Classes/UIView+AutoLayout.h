/**
 * Category Description
 *
 * This category adds easy-to-use autolayout support for UIView classes.
 *
 *
 * Instructions for using this category:
 *
 * - If you want to use autolayout for a view, you most likely want to call
 *   -[UIView useAutoLayout] before calling other methods in this category,
 *   although it is not strictly required. See the discussion of that method
 *   to learn why.
 *
 * Instructions for adding new methods:
 *
 * - If a method creates more than one constraints, there must be methods to
 *   create each individual one.
 * - If a method creates only one constraint, it must return that constraint
 *   so that the user of this category can adjust the constraint if needed.
 *
 * Version 0.1.1 @ April 8, 2014
 *
 * @author Danqing Liu (redanqing+os@gmail.com)
 */

#import <UIKit/UIKit.h>

// If we want to skip a constraint when for example using pinToParentView:withInsets:,
// specify the argument to skip by AL_SKIP (auto-layout skip). Since the underlying
// type is a CGFloat, nil or NULL won't work.
#define AL_SKIP CGFLOAT_MAX


// Specify inset on one edge isn't cool. You know what's cool? Specify insets on all four edges.
typedef struct TRBL {
  CGFloat top;
  CGFloat right;
  CGFloat bottom;
  CGFloat left;
} ALInsets;


// Specify offset on one dimension isn't cool. You know what's cool?
// Specify offsets on both X and Y dimensions.
// Well, that's just CGPoint, but to make the experience more uniform, here's a typedef.
typedef CGPoint ALOffsets;


/**
 * Convenient method to create an ALInsets struct. The order of the params
 * is clockwise, same as in CSS. To skip a direction, set it to AL_SKIP.
 *
 * @param t Top inset.
 * @param r Right inset.
 * @param b Bottom inset.
 * @param l Left inset.
 * @return An ALInsets struct containing the desired insets.
 */
CG_INLINE ALInsets ALInsetsMake(CGFloat t, CGFloat r, CGFloat b, CGFloat l)
{
  ALInsets insets;
  insets.top = t; insets.right = r; insets.bottom = b; insets.left = l;
  return insets;
}


/**
 * Convenient method to create an ALOffsets struct. The order of the params
 * is horizontal, vertical. This is simply a wrapper of CGPointMake.
 *
 * @param x Horizontal offset.
 * @param y Vertical offset.
 * @return An ALOffsets struct containing the desired offsets.
 */
CG_INLINE ALOffsets ALOffsetsMake(CGFloat x, CGFloat y)
{
  return CGPointMake(x, y);
}


@interface UIView (AutoLayout)

/**
 * Clear autoresizing mask and use autolayout.
 *
 * This will override initWithFrame method, so you must specify the layout
 * of the view using autolayout only. On the other hand, if you are using
 * autolayout, you almost always want to call this method first. Applying
 * autolayout without removing automatically converted constraints would
 * almost certainly result in conflicts or ambiguity.
 */
- (void)useAutoLayout;


# pragma mark - Pin to edge of super view

/**
 * Pin all four sides to parent view, with their respective insets.
 *
 * All insets should be non-negative, and the insets for right and bottom
 * will be automagically negated. If an edge should be skipped, specify
 * AL_SKIP for that edge.
 *
 * @param view The parent view to pin to.
 * @param insets The insets of all four sides. Use ALInsetsMake to create it.
 */
- (void)pinToParentView:(UIView *)view withInsets:(ALInsets)insets;


/**
 * Pin top to parent view, with a non-negative inset.
 *
 * @param view The parent view to pin to.
 * @param inset The top inset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)pinTopToParentView:(UIView *)view withInset:(CGFloat)inset;


/**
 * Pin right to parent view, with a non-negative inset. The inset will be negated
 * automagically, so it is to the left of the right edge of parent view.
 *
 * @param view The parent view to pin to.
 * @param inset The right inset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)pinRightToParentView:(UIView *)view withInset:(CGFloat)inset;


/**
 * Pin bottom to parent view, with a non-negative inset. The inset will be negated
 * automagically, so it is to the above of the bottom edge of parent view.
 *
 * @param view The parent view to pin to.
 * @param inset The bottom inset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)pinBottomToParentView:(UIView *)view withInset:(CGFloat)inset;


/**
 * Pin left to parent view, with a non-negative inset.
 *
 * @param view The parent view to pin to.
 * @param inset The left inset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)pinLeftToParentView:(UIView *)view withInset:(CGFloat)inset;


# pragma mark - Set dimension

/**
 * Set a fixed size for the view.
 *
 * @param size The size of the view.
 */
- (void)setFixedSize:(CGSize)size;


/**
 * Set a fixed width for the view.
 *
 * @param width The width of the view.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setFixedWidth:(CGFloat)width;


/**
 * Set a fixed height for the view.
 *
 * @param height The height of the view.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setFixedHeight:(CGFloat)height;


/**
 * Set a minimum size for the view.
 *
 * @param size The minimum size of the view.
 */
- (void)setMinimumSize:(CGSize)size;


/**
 * Set a minimum width for the view.
 *
 * @param width The width of the view.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setMinimumWidth:(CGFloat)width;


/**
 * Set a minimum height for the view.
 *
 * @param height The height of the view.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setMinimumHeight:(CGFloat)height;


# pragma mark - Center view

/**
 * Center both horizontally and vertically to parent view.
 *
 * @param view The parent view.
 * @param offset The offset from the center of the parent view. Can be
 *        both positive and negative. Use ALOffsetsMake to create it.
 */
- (void)centerToParentView:(UIView *)view withOffsets:(ALOffsets)offsets;


/**
 * Center horizontally with parent view, with an offset.
 *
 * @param view The parent view to align to.
 * @param offset The horizontal offset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)centerXToParentView:(UIView *)view withOffset:(CGFloat)offset;


/**
 * Center vertically with parent view, with an offset.
 *
 * @param view The parent view to align to.
 * @param offset The vertical offset.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)centerYToParentView:(UIView *)view withOffset:(CGFloat)offset;


# pragma mark - Relation to another view

/**
 * Set the view above the given view with a distance. Does nothing on the X direction.
 *
 * @param view The view to align to.
 * @param distance The distance between the two views. If negative, the two views would overlap.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setAboveView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView;


/**
 * Set the view below a sibling view with a distance. Does nothing on the X direction.
 *
 * @param view The view to align to.
 * @param distance The distance between the two views. If negative, the two views would overlap.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setBelowView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView;


/**
 * Set the view to the left of the given view with a distance. Does nothing on the Y direction.
 *
 * @param view The view to align to.
 * @param distance The distance between the two views. If negative, the two views would overlap.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setLeftOfView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView;


/**
 * Set the view to the right of the given view with a distance. Does nothing on the Y direction.
 *
 * @param view The view to align to.
 * @param distance The distance between the two views. If negative, the two views would overlap.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)setRightOfView:(UIView *)view withDistance:(CGFloat)distance inParentView:(UIView *)parentView;


/**
 * Align with the given view, edge to edge.
 *
 * @param view The view to align to.
 * @param offset The edge-to-edge offsets between the two views. Positive is east/south.
 * @param parentView The common parent view of the two views.
 */
- (void)alignWithView:(UIView *)view withEdgeOffsets:(ALInsets)offsets inParentView:(UIView *)parentView;


/**
 * Align the left edge with that of the given view.
 *
 * @param view The view to align to.
 * @param offset The offset between the left edges of the two views. Positive is east.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)leftAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView;


/**
 * Align the right edge with that of the given view.
 *
 * @param view The view to align to.
 * @param offset The offset between the right edges of the two views. Positive is east.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)rightAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView;


/**
 * Align the top edge with that of the given view.
 *
 * @param view The view to align to.
 * @param offset The offset between the top edges of the two views. Positive is south.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)topAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView;


/**
 * Align the bottom edge with that of the given view.
 *
 * @param view The view to align to.
 * @param offset The offset between the bottom edges of the two views. Positive is south.
 * @param parentView The common parent view of the two views.
 * @return The created constraint.
 */
- (NSLayoutConstraint *)bottomAlignWithView:(UIView *)view withOffset:(CGFloat)offset inParentView:(UIView *)parentView;

@end
