//
//  StudentInfoView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentInfoView.h"
#import "DEFINE.h"
@implementation StudentInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        //[self initView];
    }
    return self;
}
-(int)initViewModel:(StudentModel *)studentModel{
    
    NSArray *titles=@[@"姓名:",@"性别:",@"民族:",@"出生日期:",@"电话:",@"其他联系方式:",@"身份证号:",@"学院:",@"专业:",@"班级:",@"学号:",
                     @"年级:",@"宿舍:",@"培养方式:",@"学籍状态:",@"学制:",@"入学时间:",@"政治面貌:",@"生源地:"];
    NSMutableArray *values=[NSMutableArray new];
    [values addObject:studentModel.NM_T==nil?@"":studentModel.NM_T];
    [values addObject:studentModel.SE_LV==nil?@"":studentModel.SE_LV];
    [values addObject:studentModel.NT_LV==nil?@"":studentModel.NT_LV];
    [values addObject:studentModel.BD_D==nil?@"":studentModel.BD_D];
    [values addObject:studentModel.PH_P==nil?@"":studentModel.PH_P];
    if([studentModel.contcats count]>0){
        
        NSMutableArray *contactArray=[NSMutableArray new];
        for(NSDictionary *temp in studentModel.contcats){
            NSString * contactStr=[NSString stringWithFormat:@"%@  %@  %@",[temp objectForKey:@"RELATION"],[temp objectForKey:@"LXR_NAME"],[temp objectForKey:@"TEL"]];
            [contactArray addObject:contactStr];
        }
        
        [values addObject:[contactArray componentsJoinedByString:@"\n"]];
    }
    else{
        [values addObject:@""];
    }
    
    [values addObject:studentModel.SF_T==nil?@"":studentModel.SF_T];
    [values addObject:studentModel.xueyuan_name==nil?@"":studentModel.xueyuan_name];
    [values addObject:studentModel.zhuanye_name==nil?@"":studentModel.zhuanye_name];
    [values addObject:studentModel.class_name==nil?@"":studentModel.class_name];
    [values addObject:studentModel.SN_T==nil?@"":studentModel.SN_T];
    [values addObject:studentModel.NJ_D==nil?@"":studentModel.NJ_D];
    [values addObject:studentModel.sushe_name==nil?@"":studentModel.sushe_name];
    [values addObject:studentModel.PM_LV==nil?@"":studentModel.PM_LV];
    [values addObject:studentModel.XJ_LV==nil?@"":studentModel.XJ_LV];
    [values addObject:studentModel.XZ_T==nil?@"":studentModel.XZ_T];
    [values addObject:studentModel.RD_D==nil?@"":studentModel.RD_D];
    [values addObject:studentModel.PL_LV==nil?@"":studentModel.PL_LV];
    [values addObject:studentModel.ST_Z2==nil?@"":studentModel.ST_Z2];
     
    int y=0;
    for(int i=0;i<titles.count;i++){
        if(i==0||i==7){
            
            UIView *grayLine= [[UIView alloc] init];
            grayLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
            [self addSubview:grayLine];
            [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(y);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(6.0f);
            }];
            
            y+=6;
        }
        if(i==5){//其他联系方式
            UIView *tempView=[[UIView alloc] init];
            [self addSubview:tempView];
            
            
            UILabel *titleLabel=[[UILabel alloc] init];
            [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            titleLabel.textColor=[UIColor blackColor];
            titleLabel.text=titles[i];
            [tempView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView);
                make.left.equalTo(tempView).offset(15);
                make.width.mas_equalTo((kWidth-30)/4+20);
            }];
            
            UILabel *valueLabel=[[UILabel alloc] init];
            [valueLabel setFont:[UIFont systemFontOfSize:14.0]];
            valueLabel.textColor=[UIColor blackColor];
            valueLabel.textAlignment=NSTextAlignmentRight;
            valueLabel.text=values[i];
            [valueLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [valueLabel setNumberOfLines:0];
            [valueLabel sizeToFit];
            [tempView addSubview:valueLabel];
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView);
                make.right.equalTo(tempView).offset(-15);
                make.width.mas_equalTo(3*((kWidth-30)/4)-20);
            }];
            
            UIView *bottomLine= [[UIView alloc] init];
            bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
            [tempView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView).offset(50+14*([studentModel.contcats count]-1));
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(1.0f);
            }];
            
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(y);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(50+14*([studentModel.contcats count]-1));
            }];
            y+=(50+14*([studentModel.contcats count]-1));
        }
        else{
            UIView *tempView=[[UIView alloc] init];
            [self addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(y);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(50.0f);
            }];
            
            UILabel *titleLabel=[[UILabel alloc] init];
            [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            titleLabel.textColor=[UIColor blackColor];
            titleLabel.text=titles[i];
            [tempView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView);
                make.left.equalTo(tempView).offset(15);
                make.width.mas_equalTo((kWidth-30)/4);
            }];
            
            UILabel *valueLabel=[[UILabel alloc] init];
            [valueLabel setFont:[UIFont systemFontOfSize:14.0]];
            valueLabel.textColor=[UIColor blackColor];
            valueLabel.textAlignment=NSTextAlignmentRight;
            valueLabel.text=values[i];
            [tempView addSubview:valueLabel];
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView);
                make.right.equalTo(tempView).offset(-15);
                make.width.mas_equalTo(3*((kWidth-30)/4));
            }];
            
            UIView *bottomLine= [[UIView alloc] init];
            bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
            [tempView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(tempView);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(1.0f);
            }];
            y+=50;
        }
        
    }
    
    return y;
    
}

 

@end
