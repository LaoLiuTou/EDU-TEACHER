//
//  MyView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"


@protocol MyDelegate <NSObject> 
-(void)clickMenuBtn:(UIButton *)btn;
-(void)clickMyInfoBtn:(UIButton *)btn;
-(void)clickLogOutBtn:(UIButton *)btn;

@end

@interface MyView : UIView
@property (nonatomic,retain)  UIImageView *header;
@property (nonatomic,retain)  UILabel *nameLabel;
@property (nonatomic,retain) UILabel *schoolLabel;
@property (nonatomic,retain) UIButton *logOutBtn;
@property (nonatomic,retain) UIView *menuView;

@property(nonatomic,strong)id<MyDelegate>delegate;

-(int)initViewModel:(MyModel *) myModel;

@end
