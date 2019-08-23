//
//  SettingView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SettingView.h"
#import "DEFINE.h"
#import "AppDelegate.h"
@implementation SettingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        [self initView];
    }
    return self;
}


-(void) initView{
    UILabel *topLine=[[UILabel alloc] init];
    topLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6);
    }];
    
    UIView *menuView=[[UIView alloc] init];
    [self addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(60*3);
    }];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
     
    NSArray *titleArray=@[@"修改密码",@"清除缓存",@"版本号"];
    NSArray *valueArray=@[@"",@"0.0M",jbad.ourVersion];
    for(int i=0;i<titleArray.count;i++){
        UIButton *item=[[UIButton alloc] init];
        item.tag=100+i;
        [item addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(menuView).offset(60*i);
            make.left.equalTo(menuView);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(60);
        }];
        UILabel *bottomLine=[[UILabel alloc]init];
        bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
        [item addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(item);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(1.0f);
        }];
        //标题
        UILabel *menuTitle=[[UILabel alloc]init];
        [menuTitle setFont:[UIFont systemFontOfSize:16.0]];
        menuTitle.textColor=[UIColor blackColor];
        menuTitle.text=titleArray[i];
        [item addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.left.equalTo(item).offset(15);
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(60.0f);
        }];
        //value
        UILabel *valueLabel=[[UILabel alloc]init];
        valueLabel.tag=1000+i;
        [valueLabel setFont:[UIFont systemFontOfSize:14.0]];
        valueLabel.textColor=[UIColor darkGrayColor];
        valueLabel.textAlignment=NSTextAlignmentRight;
        valueLabel.text=valueArray[i];
        [item addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.right.mas_equalTo(-40);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(60.0f);
        }];
        //右箭头
        UIImageView *arrImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
        [item addSubview:arrImage];
        [arrImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
    }
    
}


-(void)clickMenuBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickMenuBtn:)]){
        [self.delegate clickMenuBtn:sender];
    }
    
}



@end
