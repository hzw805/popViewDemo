//
//  ZWSlideMenuPanelView.h
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSlideMenu.h"

@class ZWSlideMenuPanelView;
@protocol ZWSlideMenuPanelViewDelegate <NSObject>
- (void)didSelectedMenu:(ZWSlideMenu *)slideMenuPanelView atIndex:(NSInteger)index inSection:(NSUInteger)section;
@end

@protocol ZWSlideMenuPanelViewDataSource <NSObject>
- (NSInteger)numberOfSectionsInSlideMenuPanelView:(ZWSlideMenuPanelView *)slideMenuPanelView;
- (NSArray *)slideMenuPanelView:(ZWSlideMenuPanelView *)slideMenuPanelView menuItemsInSection:(NSInteger)section;
@end

@interface ZWSlideMenuPanelView : UIView

@property (nonatomic, strong) NSString *panelTitle;
@property (nonatomic, assign) BOOL showSeparateLine;
@property (assign, nonatomic) id<ZWSlideMenuPanelViewDelegate>delegate;
@property (assign, nonatomic) id<ZWSlideMenuPanelViewDataSource>dataSource;


- (instancetype)initWithTitle:(NSString *)title delegate:(id<ZWSlideMenuPanelViewDelegate>)delegate dataSource:(id<ZWSlideMenuPanelViewDataSource>)dataSource;
- (void)showSlideMenuPanel;

@end


