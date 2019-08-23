//
//  LTPickerView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/27.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTPickerDelegate <NSObject>

@optional
- (void)pickViewSureBtnClick:(NSDictionary *)selectDic;

@end

@interface LTPickerView : UIView

/*** 提供出一个数组 方便外面传递 ***/
@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic)id<LTPickerDelegate> delegate;

@end
