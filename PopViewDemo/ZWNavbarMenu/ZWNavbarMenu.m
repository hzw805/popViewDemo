//
//  ZWNavbarMenu.m
//  PopViewDemo
//
//  Created by hzw on 16/5/5.
//  Copyright © 2016年 John Huang. All rights reserved.
//

#import "ZWNavbarMenu.h"
#import "UIView+ZWExtension.h"

@implementation UITouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end

@implementation ZWMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[ZWMenuItem alloc] init:title
                              image:image
                             target:target
                             action:action];
}

- (id) init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (BOOL) enabled
{
    return _target != nil && _action != NULL;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

/////////////////////

static NSInteger rowHeight = 100;
static CGFloat titleFontSize = 12.0;
static CGFloat verSpacing = 20.0;
static CGFloat titleHeight = 20.0;
@interface ZWNavbarMenu ()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *menuBackView;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;
@property (assign, nonatomic) NSInteger numberOfRow;
@end


@implementation ZWNavbarMenu
-(id)initWithFrame:(CGRect)frame
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self = [super initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    return self;
}

- (instancetype)initWithItems:(NSArray *)items width:(CGFloat)width maximumNumberInRow:(NSInteger)max {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self == nil) return nil;
    _items = items;
    _open = NO;
    _maximumNumberInRow = max;
    _numberOfRow = (_items.count-1)/_maximumNumberInRow + 1;
    self.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _backgroundView.hidden = YES;
    [self addSubview:_backgroundView];
    
    _menuBackView = [[UIView alloc] initWithFrame:self.frame];
    _menuBackView.backgroundColor = [UIColor whiteColor];
    _menuBackView.dop_height = (_numberOfRow) * rowHeight + verSpacing*2;
    _menuBackView.dop_y =  self.frame.size.height;
    [self addSubview:_menuBackView];
    
    _beforeAnimationFrame = _menuBackView.frame;
    _afterAnimationFrame = _menuBackView.frame;
    
    UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [_backgroundView addGestureRecognizer:gr];
    _textColor = [UIColor whiteColor];
    _separatarColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = _menuBackView.dop_width/self.maximumNumberInRow;
    CGFloat buttonHeight = rowHeight;
    
    [self.items enumerateObjectsUsingBlock:^(ZWMenuItem *obj, NSUInteger idx, BOOL *stop) {
        
        
        CGFloat buttonX = (idx % self.maximumNumberInRow) * buttonWidth;
        CGFloat buttonY = verSpacing + ((idx / self.maximumNumberInRow)) * buttonHeight;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.tag = idx;
        [_menuBackView addSubview:button];
        [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:obj.image];
        icon.frame = CGRectMake(0, 0, 65, 65);
        icon.center = CGPointMake(buttonWidth/2, buttonHeight/2-15);
        [button addSubview:icon];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + 5, buttonWidth, titleHeight)];
        label.text = obj.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:titleFontSize];
        [button addSubview:label];
        if ((idx+1)%self.maximumNumberInRow != 0) {
            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth-0.5, 0, 0.5, buttonHeight)];
            separatar.backgroundColor = self.separatarColor;
            [button addSubview:separatar];
        }
        
        
        if (self.numberOfRow > 1 && idx/self.maximumNumberInRow < (self.numberOfRow-1)) {
            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight-0.5, buttonWidth, 0.5)];
            separatar.backgroundColor = self.separatarColor;
            [button addSubview:separatar];
        }
    }];
}



- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        if (self.delegate != nil) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
//            _menuBackView.dop_y += 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _menuBackView.dop_y = self.beforeAnimationFrame.origin.y;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        _menuBackView.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}


- (void)showMenu
{
    _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _backgroundView.hidden = NO;
    
    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        _menuBackView.dop_y = self.afterAnimationFrame.origin.y - _menuBackView.dop_height;
    } completion:^(BOOL finished) {
        if (self.delegate != nil) {
            [self.delegate didShowMenu:self];
        }
        self.open = YES;
    }];
    
    //将本身加在Window上
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismissMenu {
    [self dismissWithAnimation:YES];
}


- (void)performAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    // 代理模式
    if (self.delegate) {
        [self.delegate didSelectedMenu:self atIndex:button.tag];
    }

    [self dismissMenu];
    
    // 指定事件模式
    ZWMenuItem *menuItem = _items[button.tag];
    [menuItem performAction];
}

@end
