//
//  AddStudentHonorView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/24.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddStudentHonorView.h"
#import "DEFINE.h"
@interface AddStudentHonorView ()<UITextViewDelegate>

@end
@implementation AddStudentHonorView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        [self initView];
    }
    return self;
}
//type  1:all,2:指定学生名
-(void)initViewWithId:(NSString *) xs_id Name:(NSString *) xs_name{
    
    _nameLabel.text=xs_name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    _dateLabel.text=currentTimeString;
}

#pragma mark - initView
- (void)initView{
    
    //学生
    UIButton *nameback=[[UIButton alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorRGB(108,180,24);
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    _nameLabel.textColor=[UIColor blackColor];
    [nameback addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(25);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-75);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //标题
    UIButton *titleBack=[[UIButton alloc] init];
    titleBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:titleBack];
    [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *titleTitle=[[UILabel alloc] init];
    titleTitle.textColor=[UIColor blackColor];
    titleTitle.font=[UIFont systemFontOfSize:14];
    titleTitle.text=@"荣誉名称";
    [titleBack addSubview:titleTitle];
    [titleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBack).offset(15);
        make.centerY.equalTo(titleBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextField *titleTextField=[[UITextField alloc] init];
    _titleTextField=titleTextField;
    _titleTextField.backgroundColor=[UIColor whiteColor];
    _titleTextField.font=[UIFont systemFontOfSize:14];
    _titleTextField.textColor=[UIColor darkGrayColor];
    _titleTextField.textAlignment=NSTextAlignmentRight;
    [titleBack addSubview:_titleTextField];
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBack).offset(115);
        make.centerY.equalTo(titleBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //单位
    UIButton *organizationBack=[[UIButton alloc] init];
    organizationBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:organizationBack];
    [organizationBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *organizationTitle=[[UILabel alloc] init];
    organizationTitle.textColor=[UIColor blackColor];
    organizationTitle.font=[UIFont systemFontOfSize:14];
    organizationTitle.text=@"颁发机构";
    [organizationBack addSubview:organizationTitle];
    [organizationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(organizationBack).offset(15);
        make.centerY.equalTo(organizationBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextField *organizationTextField=[[UITextField alloc] init];
    _organizationTextField=organizationTextField;
    _organizationTextField.backgroundColor=[UIColor whiteColor];
    _organizationTextField.font=[UIFont systemFontOfSize:14];
    _organizationTextField.textColor=[UIColor darkGrayColor];
    _organizationTextField.textAlignment=NSTextAlignmentRight;
    [organizationBack addSubview:_organizationTextField];
    [_organizationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(organizationBack).offset(115);
        make.centerY.equalTo(organizationBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //日期
    UIButton *timeBack=[[UIButton alloc] init];
    timeBack.backgroundColor=[UIColor whiteColor];
    [timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeBack];
    [timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organizationBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *talk_timeTitle=[[UILabel alloc] init];
    talk_timeTitle.textColor=[UIColor blackColor];
    talk_timeTitle.font=[UIFont systemFontOfSize:14];
    talk_timeTitle.text=@"获得日期";
    [timeBack addSubview:talk_timeTitle];
    [talk_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(15);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *dateLabel=[[UILabel alloc] init];
    _dateLabel=dateLabel;
    _dateLabel.font=[UIFont systemFontOfSize:14];
    _dateLabel.textColor=[UIColor grayColor];
    _dateLabel.textAlignment=NSTextAlignmentRight;
    [timeBack addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(115);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //内容
//    UITextView *commentText=[[UITextView alloc] init];
//    _commentText=commentText;
//    _commentText.backgroundColor=[UIColor whiteColor];
//    _commentText.font=[UIFont systemFontOfSize:14];
//    _commentText.text = @"添加描述";
//    _commentText.textColor = GKColorRGB(197, 197, 197);
//    _commentText.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
//    _commentText.delegate=self;
//    _commentText.tag=100;
//    [self addSubview:_commentText];
//    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(timeBack.mas_bottom).offset(1);
//        make.width.mas_equalTo(kWidth);
//        make.height.mas_equalTo(100);
//        
//    }];
    
    
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
        make.top.mas_equalTo(kHeight-kNavBarHeight-50-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(40);
    }];
}




#pragma mark - 时间
-(void)clickTimeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickTimeBtn:)]){
        [self.delegate clickTimeBtn:sender];
    }
}
#pragma mark - 保存并发布
-(void)clickPublishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickPublishBtn:)]){
        [self.delegate clickPublishBtn:sender];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        switch (textView.tag) {
            case 100:
            {
                textView.text = @"添加描述";
                textView.textColor = [UIColor lightGrayColor];
            }
                
            default:
                break;
        }
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    switch (textView.tag) {
        case 100:
        {
            if([textView.text isEqualToString:@"添加描述"]){
                textView.text=@"";
                textView.textColor=[UIColor grayColor];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
