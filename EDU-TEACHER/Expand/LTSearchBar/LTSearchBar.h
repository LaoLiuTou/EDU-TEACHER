//
//  LTSearchBar.h
//
//  Created by Jiubai on 2019/4/8.
//  Copyright © 2019 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSearchBar : UISearchBar
@property (nonatomic,strong) UIColor *cursorColor;//光标颜色
@property (nonatomic,strong) UITextField *searchBarTextField;//搜索框TextField
@property (nonatomic,strong) UIImage *clearButtonImage;//输入框清除按钮图片
@property (nonatomic,assign) BOOL hideSearchBarBackgroundImage;//隐藏SearchBar背景灰色部分 默认显示
@property(nonatomic,assign)  UIEdgeInsets contentInset;
@property(nonatomic,assign) BOOL isChangeFrame;//是否要改变searchBar的frame

@property (nonatomic,assign) BOOL showCancel;//隐藏SearchBar背景灰色部分
@property (nonatomic,strong) UIButton *cancleButton;//取消按钮 showsCancelButton = YES 才能获取到

@end

NS_ASSUME_NONNULL_END
