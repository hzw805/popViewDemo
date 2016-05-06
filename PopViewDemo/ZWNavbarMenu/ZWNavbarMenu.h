//
//  ZWNavbarMenu.h
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface UITouchGestureRecognizer : UIGestureRecognizer
@end

@interface ZWMenuItem : NSObject
@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

@end


@class ZWNavbarMenu;
@protocol ZWNavbarMenuDelegate <NSObject>

- (void)didShowMenu:(ZWNavbarMenu *)menu;
- (void)didDismissMenu:(ZWNavbarMenu *)menu;
- (void)didSelectedMenu:(ZWNavbarMenu *)menu atIndex:(NSInteger)index;

@end


@interface ZWNavbarMenu : UIView
@property (copy, nonatomic, readonly)   NSArray *items;
@property (assign, nonatomic, readonly) NSInteger maximumNumberInRow; // 每行菜单数
@property (assign, nonatomic, getter = isOpen) BOOL open;
@property (weak, nonatomic) id <ZWNavbarMenuDelegate> delegate;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *separatarColor;

- (instancetype)initWithItems:(NSArray *)items
                        width:(CGFloat)width
           maximumNumberInRow:(NSInteger)max;


- (void)dismissWithAnimation:(BOOL)animation;
- (void)showMenu;
@end
