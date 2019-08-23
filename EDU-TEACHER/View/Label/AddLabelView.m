//
//  AddLabelView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddLabelView.h"
#import "DEFINE.h"
@interface AddLabelView ()<UITextViewDelegate>

@end
@implementation AddLabelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        [self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initView{
    
    
    
    
    
    //学生
    UIButton *nameback=[[UIButton alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    _nameback=nameback;
    _nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:_nameback];
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    UITextField *nameLabel=[[UITextField alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.placeholder=@"添加标签名称";
    [self.nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameback).offset(15);
        make.centerY.equalTo(self.nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.centerY.equalTo(self.nameback);
        make.width.mas_equalTo(kWidth-75);
        make.height.mas_equalTo(50.0f);
    }];
  
    
    
    //remarkTextView
    UIView *remarkBack=[[UIView alloc] init];
    remarkBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:remarkBack];
    [remarkBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(120.0f);
    }];
    UILabel *talk_timeTitle=[[UILabel alloc] init];
    talk_timeTitle.textColor=[UIColor blackColor];
    talk_timeTitle.font=[UIFont systemFontOfSize:14];
    talk_timeTitle.text=@"标签说明";
    [remarkBack addSubview:talk_timeTitle];
    [talk_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remarkBack).offset(15);
        make.top.equalTo(remarkBack).offset(15);;
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextView *remarkTextView=[[UITextView alloc] init];
    _remarkTextView=remarkTextView;
    _remarkTextView.font=[UIFont systemFontOfSize:14];
    _remarkTextView.textColor=[UIColor grayColor];
    _remarkTextView.textAlignment=NSTextAlignmentRight;
    [remarkBack addSubview:_remarkTextView];
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remarkBack).offset(115);
        make.centerY.equalTo(remarkBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(100.0f);
    }];
    
    
    
    //选择学生
    UIButton *selectStuBack=[[UIButton alloc] init];
    selectStuBack.backgroundColor=[UIColor whiteColor];
    [selectStuBack addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectStuBack];
    [selectStuBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *attaLabel=[[UILabel alloc] init];
    attaLabel.text=@"选择标签对象";
    attaLabel.font=[UIFont systemFontOfSize:14];
    attaLabel.textColor=[UIColor blackColor];
    attaLabel.textAlignment=NSTextAlignmentLeft;
    [selectStuBack addSubview:attaLabel];
    [attaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectStuBack).offset(15);
        make.centerY.equalTo(selectStuBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    UIScrollView *stuScrollView=[[UIScrollView alloc] init];
    _stuScrollView=stuScrollView;
    _stuScrollView.showsHorizontalScrollIndicator = NO;
    _stuScrollView.backgroundColor=[UIColor whiteColor];
    _stuScrollView.bounces = YES;
    [selectStuBack addSubview:_stuScrollView];
    UITapGestureRecognizer *selectStu= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectStu)];
    [_stuScrollView addGestureRecognizer:selectStu];
    [_stuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectStuBack).offset(115);
        make.centerY.equalTo(selectStuBack);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *selectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
    _selectImage=selectImage;
    [selectStuBack addSubview:_selectImage];
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectStuBack).offset(-30);
        make.centerY.equalTo(selectStuBack);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImageView *attaRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [selectStuBack addSubview:attaRightImage];
    [attaRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectStuBack).offset(-10);
        make.centerY.equalTo(selectStuBack);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    
    UIButton *publishBtn=[[UIButton alloc] init];
    _publishBtn=publishBtn;
    [self addSubview:_publishBtn];
    _publishBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_publishBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_publishBtn setTitle:@"保存" forState:UIControlStateNormal];
    _publishBtn.layer.cornerRadius=12;
    _publishBtn.layer.masksToBounds=YES;
    _publishBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(selectStuBack.mas_bottom).offset(20);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(40);
    }];
}




 
#pragma mark - 选择人员
-(void)clickSelectStu{
    if([self.delegate respondsToSelector:@selector(clickSelectStu)]){
        [self.delegate clickSelectStu];
    }
}
#pragma mark - 保存并发布
-(void)clickPublishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickPublishBtn:)]){
        [self.delegate clickPublishBtn:sender];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end

