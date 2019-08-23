//
//  TwoTitleButton.m
//  Course
//
//  Created by MacOS on 14-12-16.
//  Copyright (c) 2014年 Joker. All rights reserved.
//

#import "TwoTitleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation TwoTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    self.layer.borderColor = kLightGrayColor.CGColor;
    self.layer.borderWidth = 0.3f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _rectTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
    _rectTitleLabel.font = [UIFont fontWithName:@"Hiragino Sans GB" size:14.f];
    _rectTitleLabel.backgroundColor = [UIColor clearColor];
    _rectTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:_rectTitleLabel];
    
    _subTitileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitileLabel.textAlignment = NSTextAlignmentCenter;
    _subTitileLabel.font = [UIFont fontWithName:@"Hiragino Sans GB" size:14.f];
    _subTitileLabel.backgroundColor = [UIColor clearColor];
    _subTitileLabel.textColor = kDarkGrayColor;
    [self addSubview:_subTitileLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _rectTitleLabel.frame = CGRectMake(0, 3, self.bounds.size.width,self.bounds.size.height/2);
    _rectTitleLabel.text = self.title;
    if(_textColor){
        _rectTitleLabel.textColor = _textColor;
    }
    
    
    _subTitileLabel.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
    _subTitileLabel.text = self.subtitle;
    if(_textColor){
        _subTitileLabel.textColor = _textColor;
    }
    
    if(_title_color){
        _rectTitleLabel.textColor = _title_color;
    }
    
    if(_subtitle_color){
        _subTitileLabel.textColor = _subtitle_color;
    }

    if(_title_font){
        _rectTitleLabel.font = _title_font;
    }
    
    if(_subtitle_font){
        _subTitileLabel.font = _subtitle_font;
    }
}

@end
