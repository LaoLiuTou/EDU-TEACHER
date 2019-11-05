//
//  MyinfoView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MyinfoView.h"
#import "DEFINE.h"
#import "UIImageView+WebCache.h"
#import "ImageZoomView.h"
@implementation MyinfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        //[self initView];
    }
    return self;
}
-(int)initViewModel:(MyModel *) myModel{
    //头像
    UIView *topLine= [[UIView alloc] init];
    topLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6.0f);
    }];
    UILabel *titleLabel=[[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text=@"头像";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(48);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo((kWidth-30)/4);
    }];
    UIImageView *header=[[UIImageView alloc] init];
    _header=header;
    _header.layer.cornerRadius = 40;
    _header.userInteractionEnabled = YES;
    _header.clipsToBounds = YES;
    _header.layer.borderWidth =2.0f;//设置边框宽度
    _header.layer.borderColor = [UIColor whiteColor].CGColor;//设置边框颜色
    [self addSubview:_header];
    UITapGestureRecognizer *selectHeaderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectImage:)];
    [_header addGestureRecognizer:selectHeaderTap];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(kWidth-15-80);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(80.0f);
    }];
 
    [_header sd_setImageWithURL:[NSURL URLWithString:myModel.image] placeholderImage:[UIImage imageNamed:@"tx_fd"]];
    
    UIImageView *headerIcon=[[UIImageView alloc] init];
    [headerIcon setImage:[UIImage imageNamed:@"header_icon"]];
    [self addSubview:headerIcon];
    [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.header.mas_right) ;
        make.bottom.equalTo(self.header.mas_bottom) ;
        make.width.mas_equalTo(28.0f);
        make.height.mas_equalTo(28.0f);
    }];
    
    
    
    UIView *bottomLine= [[UIView alloc] init];
    bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6.0f);
    }];
    
    //信息
    NSArray *titles=@[@"姓名:",@"性别:",@"学院:",@"角色:",@"手机号:",@"身份证号:",@"身份证照片:"];
    NSMutableArray *values=[NSMutableArray new];
    [values addObject:myModel.name==nil?@"":myModel.name];
    [values addObject:myModel.sex==nil?@"":myModel.sex];
    [values addObject:myModel.ac_name==nil?@"":myModel.ac_name];
    [values addObject:myModel.role==nil?@"":myModel.role];
    [values addObject:myModel.phone==nil?@"":myModel.phone];
    if(myModel.id_card.length>4){
        [values addObject:[NSString stringWithFormat:@"**************%@",[myModel.id_card substringFromIndex:myModel.id_card.length-4]]];
    }
    else{
        [values addObject:myModel.id_card];
    }
    
    [values addObject:myModel.idcard_image==nil?@"":myModel.idcard_image];
    int y=112;
    for(int i=0;i<titles.count;i++){
        if(i==6){
            UIView *tempView=[[UIView alloc] init];
            [self addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(y);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(150.0f);
            }];
            
            UILabel *titleLabel=[[UILabel alloc] init];
            [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            titleLabel.textColor=[UIColor blackColor];
            titleLabel.text=titles[i];
            [tempView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView).offset(15);
                make.left.equalTo(tempView).offset(15);
                make.width.mas_equalTo((kWidth-30)/4);
            }];
            
            UIImageView *idImageView=[[UIImageView alloc] init];
            idImageView.layer.cornerRadius = 8;
            idImageView.contentMode = UIViewContentModeScaleAspectFill;
            idImageView.clipsToBounds = YES; // 裁剪边缘
            idImageView.userInteractionEnabled = YES;
            _idImageView=idImageView;
            [tempView addSubview:_idImageView];
            
            UITapGestureRecognizer *selectIdImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIdImage:)];
            [_idImageView addGestureRecognizer:selectIdImageTap];
            [_idImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tempView).offset(15);
                make.right.equalTo(tempView.mas_right).offset(-15) ;
                make.width.mas_equalTo(180.0f);
                make.height.mas_equalTo(120.0f);
            }];
            if(![values[i] isEqualToString:@""]){
                [_idImageView sd_setImageWithURL:[NSURL URLWithString:values[i]]];
            }
          
            
            UIView *bottomLine= [[UIView alloc] init];
            bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
            [tempView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(tempView);
                make.width.mas_equalTo(kWidth);
                make.height.mas_equalTo(1.0f);
            }];
            y+=150;
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

-(void)clickSelectImage:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(clickSelectImage:)]){
        [self.delegate clickSelectImage:tap];
    }
}
-(void)clickIdImage:(UITapGestureRecognizer *)tap  {
   
    ImageZoomView *imageZoomView=[[ImageZoomView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andWithImage: _idImageView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageZoomView];
}

@end
