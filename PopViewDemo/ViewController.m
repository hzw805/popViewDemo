//
//  ViewController.m
//  PopViewDemo
//
//  Created by hzw on 16/5/3.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import "ViewController.h"

#import "ZWNavbarMenu.h"
#import "ZWSlideMenu/ZWSlideMenuPanelView.h"

@interface ViewController ()<ZWSlideMenuPanelViewDelegate, ZWSlideMenuPanelViewDataSource, ZWNavbarMenuDelegate>
@property (assign, nonatomic) NSInteger numberOfItemsInRow;
@property (strong, nonatomic) ZWNavbarMenu *menu;
@property (strong, nonatomic) ZWSlideMenuPanelView *slideView;
@end

@implementation ViewController

// 面板模式
- (ZWNavbarMenu *)menu {
    if (_menu == nil) {
        
        NSArray *menuItems =
        
//        @[[ZWMenuItem menuItem:@"编辑资料"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action0)],
//          [ZWMenuItem menuItem:@"修改密码"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action1)],
//          [ZWMenuItem menuItem:@"退出登录"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action2)],
//          [ZWMenuItem menuItem:@"编辑资料"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action3)],
//          [ZWMenuItem menuItem:@"修改密码"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action4)],
//          [ZWMenuItem menuItem:@"退出登录"
//                         image:[UIImage imageNamed:@"0"]
//                        target:self
//                        action:@selector(action5)]];
        
        
        // 代理模式
      @[[ZWMenuItem menuItem:@"编辑资料"
                         image:[UIImage imageNamed:@"0"]
                        target:self
                        action:nil],
          [ZWMenuItem menuItem:@"修改密码"
                         image:[UIImage imageNamed:@"1"]
                        target:self
                        action:nil],
          [ZWMenuItem menuItem:@"退出登录"
                         image:[UIImage imageNamed:@"2"]
                        target:self
                        action:nil],
          [ZWMenuItem menuItem:@"编辑资料"
                         image:[UIImage imageNamed:@"3"]
                        target:self
                        action:nil],
          [ZWMenuItem menuItem:@"修改密码"
                         image:[UIImage imageNamed:@"4"]
                        target:self
                        action:nil],
          [ZWMenuItem menuItem:@"退出登录"
                         image:[UIImage imageNamed:@"5"]
                        target:self
                        action:nil]];

        
        CGFloat screenWidth = self.view.bounds.size.width;
        
        _menu = [[ZWNavbarMenu alloc] initWithItems:menuItems width:screenWidth maximumNumberInRow:_numberOfItemsInRow];
        _menu.delegate = self;
        _menu.separatarColor = [UIColor lightGrayColor];
        _menu.textColor = [UIColor blackColor];
       
    }
    return _menu;
}


// 滑动菜单模式
- (ZWSlideMenuPanelView *)slideView
{
    if (_slideView == nil) {
 
        _slideView = [[ZWSlideMenuPanelView alloc] initWithTitle:@"网页提供者" delegate:self dataSource:self];
        _slideView.showSeparateLine = YES;

    }
 
    return _slideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"面板菜单" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.numberOfItemsInRow = 3;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"滑动面板菜单" style:UIBarButtonItemStylePlain target:self action:@selector(openSlideMenu:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}


- (void)openMenu:(id)sender
{
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showMenu];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)action0
{
    NSLog(@"item:0");
}

- (void)action1
{
    NSLog(@"item:1");
}
- (void)action2
{
    NSLog(@"item:2");
}
- (void)action3
{
    NSLog(@"item:3");
}
- (void)action4
{
    NSLog(@"item:4");
}
- (void)action5
{
    NSLog(@"item:5");
}



#pragma mark - ZWNavbarMenuDelegate
- (void)didShowMenu:(ZWNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"隐藏"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(ZWNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"菜单"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (void)didSelectedMenu:(ZWNavbarMenu *)menu atIndex:(NSInteger)index {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"你点击了" message:[NSString stringWithFormat:@"item%@", @(index+1)] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [av show];
}



- (void)openSlideMenu:(id)sender
{
    [self.slideView showSlideMenuPanel];
}


#pragma mark - ZWSlideMenuPanelViewDelegate
- (void)didSelectedMenu:(ZWSlideMenuPanelView *)slideMenuPanelView atIndex:(NSInteger)index inSection:(NSUInteger)section
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"你点击了" message:[NSString stringWithFormat:@"section为%@的item%@", @(section+1),@(index+1)] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [av show];
}


#pragma mark - ZWSlideMenuPanelViewDataSource
- (NSInteger)numberOfSectionsInSlideMenuPanelView:(ZWSlideMenuPanelView *)slideMenuPanelView
{
    return 2;
}
- (NSArray *)slideMenuPanelView:(ZWSlideMenuPanelView *)slideMenuPanelView menuItemsInSection:(NSInteger)section
{
    NSMutableArray *items = [NSMutableArray array];
    
    ZWSlideMenuItem *item1 = [ZWSlideMenuItem menuItem:@"新浪微博" icon:[UIImage imageNamed:@"0"]];
    [items addObject:item1];
    
    ZWSlideMenuItem *item2 = [ZWSlideMenuItem menuItem:@"腾讯微博" icon:[UIImage imageNamed:@"1"]];
    [items addObject:item2];
    
    ZWSlideMenuItem *item3 = [ZWSlideMenuItem menuItem:@"QQ空间" icon:[UIImage imageNamed:@"2"]];
    [items addObject:item3];
    
    ZWSlideMenuItem *item4 = [ZWSlideMenuItem menuItem:@"微信" icon:[UIImage imageNamed:@"3"]];
    [items addObject:item4];
    
    ZWSlideMenuItem *item5 = [ZWSlideMenuItem menuItem:@"朋友圈" icon:[UIImage imageNamed:@"4"]];
    [items addObject:item5];
    
    ZWSlideMenuItem *item6 = [ZWSlideMenuItem menuItem:@"QQ" icon:[UIImage imageNamed:@"5"]];
    [items addObject:item6];
    
    
    if (section == 0) {
        return items;
    }
    
    else
    {
        [items removeLastObject];
        [items removeObjectAtIndex:0];
        return items;
    }
    
//    ZWSlideMenuItem *item2 = [ZWSlideMenuItem item];
//    item2.title = @"服务";
//    item2.icon = [UIImage imageNamed:@"1"];
//    item2.titleFont = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:12];
//    [items addObject:item2];
//    
//    ZWSlideMenuItem *item3 = [ZWSlideMenuItem item];
//    item3.title = @"关于";
//    item3.icon = [UIImage imageNamed:@"2"];
//    item3.titleFont = [UIFont fontWithName:@"Papyrus" size:12];
//    [items addObject:item3];
//    
//    ZWSlideMenuItem *item4 = [ZWSlideMenuItem item];
//    item4.title = @"我的";
//    item4.icon = [UIImage imageNamed:@"3"];
//    item4.titleFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
//    [items addObject:item4];
//    
//    ZWSlideMenuItem *item5 = [ZWSlideMenuItem item];
//    item5.title = @"更多";
//    item5.icon = [UIImage imageNamed:@"4"];
//    item5.titleFont =[UIFont systemFontOfSize:12];
//    [items addObject:item5];
    
    return items;
}
@end
