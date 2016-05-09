弹出面板视图
包含两种模式：1、普通面板模式，类似于一些第三方分享面板界面，如友盟、shareSDK界面等；2、滑动面板模式，可以由多个滑动面板组合，动态添加菜单项，类似于微信新闻页的分享弹出界面。两者均带有蒙版效果。

代码调用简单易行
1.普通面板调用如下：
NSArray *menuItems =
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
[_menu showMenu];


2.滑动面板调用样式
// 滑动菜单模式
- (ZWSlideMenuPanelView *)slideView
{
if (_slideView == nil) {

_slideView = [[ZWSlideMenuPanelView alloc] initWithTitle:@"网页提供者" delegate:self dataSource:self];
_slideView.showSeparateLine = YES;

}

return _slideView;
}


- (void)openSlideMenu:(id)sender
{
[self.slideView showSlideMenuPanel];
}

// 实现代理和数据源方法
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


return items;
}



1 普通面板样式 /<br>
![images](https://github.com/hzw805/popViewDemo/raw/master/imgs/普通弹出面板.png) /<br>

2 滑动式面板样式/<br>
![images](https://github.com/hzw805/popViewDemo/raw/master/imgs/滑动式面板.png)/<br>


