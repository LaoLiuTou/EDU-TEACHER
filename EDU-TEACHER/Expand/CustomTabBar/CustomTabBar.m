//
//  CustomTabBar.m
//  XianYuCustomTabBar
//
//  Created by jiang on 2017/3/9.
//  Copyright © 2017年 skydrui.regular. All rights reserved.
//

#import "CustomTabBar.h"
#import "CustomButton.h"

@interface CustomTabBar ()
@property(nonatomic, strong)NSMutableArray *tabbarBtnArray;
@property(nonatomic, weak)UIButton *postBtn;
@property(nonatomic, weak)CustomButton *selectedButton;
@end

@implementation CustomTabBar

- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupPostButton];
        
    }
    
    return self;
}

- (void)setupPostButton {
  
    UIButton * postBtn = [UIButton new];
     
    postBtn.adjustsImageWhenHighlighted = NO;
    [postBtn setImage:[UIImage imageNamed:@"tanc-daiyinying"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[postBtn setTitle:@"发布" forState:UIControlStateNormal];
    //postBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    //[postBtn setTitleColor:[UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:1.0] forState:UIControlStateNormal];
    postBtn.bounds =CGRectMake(0, 0, 64, 64);
    [postBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, -15, 0)];
    //[postBtn setTitleEdgeInsets:UIEdgeInsetsMake(78, 0, 0, 0)];
    [self addSubview:postBtn];
    self.postBtn = postBtn;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.postBtn.center = CGPointMake(self.frame.size.width * 0.5, 0);
    
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.subviews.count);
    CGFloat btnH = self.frame.size.height;
    
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        CustomButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        if (nIndex > 1) {
            btnX += btnW;
        }
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
         
    }
    
}

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem {
    CustomButton * tabBarBtn = [CustomButton new];
    [self addSubview:tabBarBtn];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.tabbarBtnArray addObject:tabBarBtn];
    
    //default selected first one
    if (self.tabbarBtnArray.count == 1) {
        [self tabBarBtnClick:tabBarBtn];
    }
    
}

- (void)tabBarBtnClick:(CustomButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    [self hiddenUITabBarButton];
}
- (void)hiddenUITabBarButton{
    if ([self.superview isKindOfClass:[UITabBar class]]) {
        UITabBar *tabbar = (UITabBar *)self.superview;
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIView *btn in tabbar.subviews) {
                    if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                        btn.hidden = YES;
                    }
                }
                [self.superview bringSubviewToFront:self]; // 放置到最前
            });
        });
    }
}
- (void)postAddBtn :(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(postAddBtn:)]) {
        [self.delegate postAddBtn:button];
    }
}

 
@end
