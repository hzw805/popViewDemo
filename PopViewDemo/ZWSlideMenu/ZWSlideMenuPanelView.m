//
//  ZWSlideMenuPanelView.m
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import "ZWSlideMenuPanelView.h"

#define kZWMenuHeight 100
#define kZWTitlePanelHeight 20
#define kZWCancelButtonHeight 40
#define kVerSpacing 10
@interface ZWSlideMenuPanelView ()<ZWSlideMenuDelegate>
{

    CGRect beforeAnimationFrame;
    CGRect afterAnimationFrame;
    NSInteger numberOfSections;
    NSMutableArray *scrollerArray;
    NSMutableArray *separateLineArray;
}
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *menuBackView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *cancelBtn;

@end

@implementation ZWSlideMenuPanelView

-(id)initWithFrame:(CGRect)frame
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self = [super initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    return self;
}


- (instancetype)initWithTitle:(NSString *)title delegate:(id<ZWSlideMenuPanelViewDelegate>)delegate dataSource:(id<ZWSlideMenuPanelViewDataSource>)dataSource
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self == nil) return nil;
    
    _panelTitle = title;
    _delegate = delegate;
    _dataSource = dataSource;
    
    _showSeparateLine = YES;
    
    numberOfSections = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInSlideMenuPanelView:)]) {
        numberOfSections = [self.dataSource numberOfSectionsInSlideMenuPanelView:self];
    }
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _backgroundView.hidden = YES;
        [self addSubview:_backgroundView];
    }
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSlideMenuPanel)];
    [_backgroundView addGestureRecognizer:gr];
    
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc] init];
        _menuBackView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        
        [self addSubview:_menuBackView];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.text = title;
        [_menuBackView addSubview:_titleLabel];
    }
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(dismissSlideMenuPanel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_menuBackView addSubview:_cancelBtn];
    }
    
    scrollerArray = [NSMutableArray arrayWithCapacity:0];
    separateLineArray = [NSMutableArray arrayWithCapacity:0];

    [self reloadData];
    
    
    return self;
}
- (void)reloadData{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInSlideMenuPanelView:)]) {
        numberOfSections = [self.dataSource numberOfSectionsInSlideMenuPanelView:self];
    }
    
    [scrollerArray removeAllObjects];
    for (NSInteger i = 0; i < numberOfSections; i ++ ) {
        ZWSlideMenu *slideMenu = [[ZWSlideMenu alloc] init];
        slideMenu.frame = CGRectMake(0, 0, self.frame.size.width, kZWMenuHeight);
        NSArray *items;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(slideMenuPanelView:menuItemsInSection:)]) {
            items = [[self.dataSource slideMenuPanelView:self menuItemsInSection:i] mutableCopy];
            slideMenu.items = [items mutableCopy];
        }
        slideMenu.section = i;
        slideMenu.menudelegate = self;
        slideMenu.showsHorizontalScrollIndicator = NO;
        slideMenu.showsVerticalScrollIndicator = NO;
        [slideMenu layoutSlideScrollViewWithItems:items];
        [slideMenu setBackgroundColor:[UIColor clearColor]
                      indicatorStyle:UIScrollViewIndicatorStyleWhite
                     itemBorderColor:[UIColor whiteColor]];
        [_menuBackView addSubview:slideMenu];
        [scrollerArray addObject:slideMenu];
        
        if (i != numberOfSections - 1) {
            UIView *line = [[UIView alloc] init];
            if (_showSeparateLine) {
                line.hidden = NO;
            }
            else
            {
                line.hidden = YES;
            }
            line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
            line.backgroundColor = [UIColor grayColor];
            [_menuBackView addSubview:line];
            [separateLineArray addObject:line];
        }
    }
    
    CGFloat panelHeight = kZWMenuHeight*numberOfSections + kZWTitlePanelHeight + kZWCancelButtonHeight + 2*kVerSpacing + (numberOfSections-1)*kVerSpacing*2;
    _menuBackView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, panelHeight);
    beforeAnimationFrame = _menuBackView.frame;
    afterAnimationFrame  = CGRectMake(0, self.frame.size.height - panelHeight, self.frame.size.width, panelHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, kZWTitlePanelHeight);
    
    for (int i = 0; i < scrollerArray.count; i ++ ) {
        ZWSlideMenu *slideMenu = [scrollerArray objectAtIndex:i];
        slideMenu.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + kVerSpacing + i*(kZWMenuHeight+kVerSpacing*2), self.frame.size.width, kZWMenuHeight);
        
        if (i < separateLineArray.count) {
            UIView *line = separateLineArray[i];
            line.frame = CGRectMake(0, CGRectGetMaxY(slideMenu.frame) + kVerSpacing , self.frame.size.width, 0.5);
        }
    }
    
//    scroller.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + kVerSpacing, self.frame.size.width, kZWMenuHeight);
    _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_menuBackView.frame)-kZWCancelButtonHeight, self.frame.size.width, kZWCancelButtonHeight);
    
}

- (void)setShowSeparateLine:(BOOL)showSeparateLine
{
    _showSeparateLine = showSeparateLine;
    if (_showSeparateLine) {
        if (separateLineArray && separateLineArray.count > 0) {
            for (UIView *line in separateLineArray) {
                line.hidden = NO;
            }
        }
    }
    else
    {
        if (separateLineArray && separateLineArray.count > 0) {
            for (UIView *line in separateLineArray) {
                line.hidden = YES;
            }
        }
    }
    
    
}

- (void)showSlideMenuPanel
{
    _backgroundView.hidden = NO;
    
    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        _menuBackView.frame = afterAnimationFrame;
    } completion:^(BOOL finished) {

    }];
    
    //将本身加在Window上
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}


- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
    };
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
          
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _menuBackView.frame = beforeAnimationFrame;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        _menuBackView.frame = beforeAnimationFrame;
        completion();
    }
}


- (void)dismissSlideMenuPanel
{
    [self dismissWithAnimation:YES];
}

#pragma mark - ZWSlideMenuDelegate
- (void)didSelectedMenu:(ZWSlideMenu *)menu atIndex:(NSInteger)index inSection:(NSUInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedMenu:atIndex:inSection:)]) {
        [_delegate didSelectedMenu:menu atIndex:index inSection:section];
    }
    
    [self dismissSlideMenuPanel];
}


@end
