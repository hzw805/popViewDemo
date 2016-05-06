//
//  ZWSlideMenu.m
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import "ZWSlideMenu.h"

#define kZWSlideMenuItemTitleFont [UIFont systemFontOfSize:12]
#define kZWSlideMenuItemTitleColor [UIColor grayColor]

@interface ZWSlideMenuItem ()

@property (nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic) id object;

@end
@implementation ZWSlideMenuItem
+ (ZWSlideMenuItem *)item
{
    ZWSlideMenuItem *newItem = [[ZWSlideMenuItem alloc] init];
    newItem.title = nil;
    newItem.icon  = nil;
    newItem.target = nil;
    newItem.action = nil;
    newItem.titleFont = kZWSlideMenuItemTitleFont;
    newItem.titleColor = kZWSlideMenuItemTitleColor;
    
    return newItem;
}

+ (ZWSlideMenuItem *)menuItem:(NSString *)title icon:(UIImage *)icon
{
    ZWSlideMenuItem *newItem = [[ZWSlideMenuItem alloc] init];
    newItem.title = title;
    newItem.icon  = icon;
    newItem.target = nil;
    newItem.action = nil;
    newItem.titleFont = kZWSlideMenuItemTitleFont;
    newItem.titleColor = kZWSlideMenuItemTitleColor;
    
    return newItem;
}

- (void)setTarget:(id)target action:(SEL)action withObject:(id)object
{
    self.target = target;
    self.action = action;
    self.object = object;
}
@end

//////////////////////////////////////

/* Default Settings */
#define kZWSlideMenuBackgroundColor [UIColor whiteColor]
#define kZWSlideMenuIndicatorStyle  UIScrollViewIndicatorStyleDefault
#define kZWSlideMenuItemBorderColor [UIColor blackColor]

/* Buffer distances */
#define kVerticalBuffer 10.0f
#define kHorizontalBuffer kVerticalBuffer
#define kTitleHeight 15.0
#define kMenuItemWidth 70

@interface ZWSlideMenu ()
{
    CGFloat leftLength;
    CGFloat width;
    UIColor *_borderColor;
}

@end

@implementation ZWSlideMenu

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults {
    self.scrollsToTop = NO;
    leftLength = kHorizontalBuffer;
    
    /* Default settings */
    [self setBackgroundColor:kZWSlideMenuBackgroundColor
              indicatorStyle:kZWSlideMenuIndicatorStyle
             itemBorderColor:kZWSlideMenuItemBorderColor];
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
            indicatorStyle:(UIScrollViewIndicatorStyle)style
           itemBorderColor:(UIColor *)borderColor
{
    self.backgroundColor = backgroundColor;
    self.indicatorStyle = style;
    _borderColor = borderColor;
}

- (void)layoutSlideScrollViewWithItems:(NSArray *)items
{
    [self removeAllItems];
    
    self.items = [items mutableCopy];

    width = kMenuItemWidth;
    CGFloat height = self.frame.size.height;
    
    /* Raise an exception if items contains foreign-typed objects */
    if (![self arrayContainsItemObjects:items]) {
        [NSException raise:@"ZWSlideMenu array of wrong type" format:@"Array passed into layoutSlideScrollViewWithItems: contains objects that are not of type ZWSlideMenuItem."];
    }
    
    for (int i = 0; i < items.count; i++) {
        ZWSlideMenuItem *item = items[i];
        
        /* Create each square button */
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftLength, 0, width, height );
      
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        icon.image = item.icon;
        [btn addSubview:icon];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+5, width, height - width - 5)];
        titleLabel.text = item.title;
        titleLabel.font = item.titleFont;
        titleLabel.textColor = item.titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        
        /* Set the item's action */
        btn.tag = i;
        [btn addTarget:self
                action:@selector(buttonTapped:)
      forControlEvents:UIControlEventTouchUpInside];
        
    
        
        [self addSubview:btn];
        
        leftLength += width + kHorizontalBuffer;
    }
    
    self.contentSize = CGSizeMake(leftLength, self.frame.size.height);
}

- (void)buttonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSUInteger idx = btn.tag;
    ZWSlideMenuItem *item = self.items[idx];
    
    if (_menudelegate && [_menudelegate respondsToSelector:@selector(didSelectedMenu:atIndex:inSection:)]) {
        [_menudelegate didSelectedMenu:self atIndex:btn.tag inSection:_section];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (item.target != nil && item.action != nil) {
        [item.target performSelector:item.action withObject:item.object];
    }
    
#pragma clang diagnostic pop
}

/* Returns YES if array contains only ZWSlideMenuItem objects,
 * NO otherwise.
 */
- (BOOL)arrayContainsItemObjects:(NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        if (![array[i] isMemberOfClass:[ZWSlideMenuItem class]])
            return NO;
    }
    
    return YES;
}

- (void)removeAllItems {
    [self.items removeAllObjects];
    leftLength = kHorizontalBuffer;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Scrolling methods

- (void)scrollToLeftmost {
    CGRect left = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:left animated:YES];
}

- (void)scrollToItemAtIndex:(NSUInteger)index {
    CGFloat x = (kHorizontalBuffer+width) * (index+1);
    [self scrollRectToVisible:CGRectMake(x, 1, 2*width, 1) animated:YES];
}

@end
