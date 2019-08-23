//
//  TwoTitleButton.h
//  Course
//
//  Created by MacOS on 14-12-16.
//  Copyright (c) 2014年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTable.h"
@interface TwoTitleButton : UIButton
{
    UILabel *_rectTitleLabel;
    UILabel *_subTitileLabel;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@property (nonatomic,retain) UIColor *textColor;

@property (nonatomic,retain) UIColor *title_color;
@property (nonatomic,retain) UIColor *subtitle_color;

@property (nonatomic,retain) UIFont *title_font;
@property (nonatomic,retain) UIFont *subtitle_font;

@end
