//
//  ZWSlideMenu.h
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 滑动菜单项  类似于微信分享面板
 */
@interface ZWSlideMenuItem : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL action;
@property (nonatomic, readonly) id object;

+ (ZWSlideMenuItem *)item;
+ (ZWSlideMenuItem *)menuItem:(NSString *)title icon:(UIImage *)icon;

- (void)setTarget:(id)target action:(SEL)action withObject:(id)object;
@end

@class ZWSlideMenu;
@protocol ZWSlideMenuDelegate <NSObject>
- (void)didSelectedMenu:(ZWSlideMenu *)menu atIndex:(NSInteger)index inSection:(NSUInteger)section;
@end

@interface ZWSlideMenu : UIScrollView
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSUInteger section;
@property (weak, nonatomic) id <ZWSlideMenuDelegate> menudelegate;

- (void)setBackgroundColor:(UIColor *)backgroundColor
            indicatorStyle:(UIScrollViewIndicatorStyle)style
           itemBorderColor:(UIColor *)borderColor;

- (void)layoutSlideScrollViewWithItems:(NSArray *)items;
@end
