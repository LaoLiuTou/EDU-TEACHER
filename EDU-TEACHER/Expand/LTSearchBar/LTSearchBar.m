//
//  LTSearchBar.m 
//
//  Created by Jiubai on 2019/4/8.
//  Copyright © 2019 JiubaiMacmini. All rights reserved.
//

#import "LTSearchBar.h"

@implementation LTSearchBar


//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    for (UIView *subView in self.subviews[0].subviews) {
//        
//        if ([subView isKindOfClass:[UIImageView class]]) {
//            
//            //移除UISearchBarBackground
//            [subView removeFromSuperview];
//        }
//        if ([subView isKindOfClass:[UITextField class]]) {
//            
//            CGFloat height = self.bounds.size.height;
//            CGFloat width = self.bounds.size.width;
//            
//            if (_isChangeFrame) {
//                //说明contentInset已经被赋值
//                // 根据contentInset改变UISearchBarTextField的布局
//                subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - 2 * _contentInset.left, height - 2 * _contentInset.top);
//            } else {
//                
//                // contentSet未被赋值
//                // 设置UISearchBar中UISearchBarTextField的默认边距
//                CGFloat top = (height - 28.0) / 2.0;
//                CGFloat bottom = top;
//                CGFloat left = 8.0;
//                CGFloat right = left;
//                _contentInset = UIEdgeInsetsMake(top, left, bottom, right);
//            }
//        }
//    }
//}

#pragma mark - set method
- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    _contentInset.top = contentInset.top;
    _contentInset.bottom = contentInset.bottom;
    _contentInset.left = contentInset.left;
    _contentInset.right = contentInset.right;
    
    self.isChangeFrame = YES;
    //[self layoutSubviews];
}

- (void)setIsChangeFrame:(BOOL)isChangeFrame {
    
    if (_isChangeFrame != isChangeFrame) {
        
        _isChangeFrame = isChangeFrame;
    }
}



//设置输入框光标颜色
- (void)setCursorColor:(UIColor *)cursorColor
{
    if (cursorColor) {
        _cursorColor = cursorColor;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //光标颜色
            [searchField setTintColor:cursorColor];
        }
    }
}

//获取输入框
- (UITextField *)searchBarTextField
{
    //获取输入框
    _searchBarTextField = [self valueForKey:@"searchField"];
    return _searchBarTextField;
}

//设置清除按钮图标
- (void)setClearButtonImage:(UIImage *)clearButtonImage
{
    if (clearButtonImage) {
        _clearButtonImage = clearButtonImage;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //设置清除按钮图片
            UIButton *button = [searchField valueForKey:@"_clearButton"];
            [button setImage:clearButtonImage forState:UIControlStateNormal];
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
}

- (void)setHideSearchBarBackgroundImage:(BOOL)hideSearchBarBackgroundImage {
    if (hideSearchBarBackgroundImage) {
        _hideSearchBarBackgroundImage = hideSearchBarBackgroundImage;
        self.backgroundImage = [[UIImage alloc] init];
    }
}

//获取取消按钮
- (UIButton *)cancleButton
{
    self.showsCancelButton = _showCancel;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            _cancleButton = (UIButton *)view;
        }
    }
    return _cancleButton;
}

@end
