//
//  AddStudentTalkingView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/22.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddStudentTalkingView.h"
#import "DEFINE.h"    
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h" 

@interface AddStudentTalkingView ()<UITextViewDelegate>

@end
@implementation AddStudentTalkingView

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
     //
    if(xs_id==nil){
        UIView *leftview=[[UIView alloc] init];
        leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
        UILabel *nameLabel=[[UILabel alloc] init];
        _nameLabel=nameLabel;
        _nameLabel.backgroundColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont systemFontOfSize:14];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.text=@"相关学生";
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
        UIImageView *selectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
        _selectImage=selectImage;
        [self.nameback addSubview:_selectImage];
        [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nameback).offset(-30);
            make.centerY.equalTo(self.nameback);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        UIImageView *selectRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
        [self.nameback addSubview:selectRightImage];
        [selectRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nameback).offset(-10);
            make.centerY.equalTo(self.nameback);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];
    }
    else{
        UIView *leftview=[[UIView alloc] init];
        leftview.backgroundColor=GKColorRGB(234, 37, 0);
        UILabel *nameLabel=[[UILabel alloc] init];
        _nameLabel=nameLabel;
        _nameLabel.backgroundColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont systemFontOfSize:14];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.text=xs_name;
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
        
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    _talk_timeLabel.text=currentTimeString;
}

#pragma mark - initView
- (void)initView{
    
    //学生
    UIButton *nameback=[[UIButton alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    _nameback=nameback;
    _nameback.backgroundColor=[UIColor whiteColor];
    [_nameback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameback];
 
    
  
    
    
    //谈话时间
    UIButton *timeBack=[[UIButton alloc] init];
    timeBack.backgroundColor=[UIColor whiteColor];
    [timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeBack];
    [timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *talk_timeTitle=[[UILabel alloc] init];
    talk_timeTitle.textColor=[UIColor blackColor];
    talk_timeTitle.font=[UIFont systemFontOfSize:14];
    talk_timeTitle.text=@"谈话时间";
    [timeBack addSubview:talk_timeTitle];
    [talk_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(15);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *talk_timeLabel=[[UILabel alloc] init];
    _talk_timeLabel=talk_timeLabel;
    _talk_timeLabel.font=[UIFont systemFontOfSize:14];
    _talk_timeLabel.textColor=[UIColor grayColor];
    _talk_timeLabel.textAlignment=NSTextAlignmentRight;
    [timeBack addSubview:_talk_timeLabel];
    [_talk_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(115);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //谈话地点
    UIView *addressBack=[[UIView alloc] init];
    addressBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:addressBack];
    [addressBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *addressTitle=[[UILabel alloc] init];
    addressTitle.textColor=[UIColor blackColor];
    addressTitle.font=[UIFont systemFontOfSize:14];
    addressTitle.text=@"谈话地址";
    [addressBack addSubview:addressTitle];
    [addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressBack).offset(15);
        make.centerY.equalTo(addressBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextField *addressText=[[UITextField alloc] init];
    _addressText=addressText;
    _addressText.font=[UIFont systemFontOfSize:14];
    _addressText.textColor=[UIColor grayColor];
    _addressText.textAlignment=NSTextAlignmentRight;
    [addressBack addSubview:_addressText];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressBack).offset(115);
        make.centerY.equalTo(addressBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //原因
    UITextView *reasonText=[[UITextView alloc] init];
    _reasonText=reasonText;
    _reasonText.backgroundColor=[UIColor whiteColor];
    _reasonText.font=[UIFont systemFontOfSize:14];
    _reasonText.text = @"添加谈话事由";
    _reasonText.textColor = GKColorRGB(197, 197, 197);
    _reasonText.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _reasonText.delegate=self;
    _reasonText.tag=100;
    [self addSubview:_reasonText];
    [_reasonText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100);
        
    }];
    
    //内容
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加谈话内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _commentText.delegate=self;
    _commentText.tag=101;
    [self addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonText.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100);
        
    }];
 
    //后续
    UITextView *followText=[[UITextView alloc] init];
    _followText=followText;
    _followText.backgroundColor=[UIColor whiteColor];
    _followText.font=[UIFont systemFontOfSize:14];
    _followText.text = @"添加后续关注措施";
    _followText.textColor = GKColorRGB(197, 197, 197);
    _followText.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _followText.delegate=self;
    _followText.tag=102;
    [self addSubview:_followText];
    [_followText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentText.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100);
        
    }];
    
    //添加附件
    UIButton *attaback=[[UIButton alloc] init];
    attaback.backgroundColor=[UIColor whiteColor];
    [attaback addTarget:self action:@selector(clickSelectAtta) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attaback];
    [attaback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followText.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *attaLabel=[[UILabel alloc] init];
    attaLabel.text=@"添加文件";
    attaLabel.font=[UIFont systemFontOfSize:14];
    attaLabel.textColor=[UIColor blackColor];
    attaLabel.textAlignment=NSTextAlignmentLeft;
    [attaback addSubview:attaLabel];
    [attaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attaback).offset(15);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    UIScrollView *filesScrollView=[[UIScrollView alloc] init];
    _filesScrollView=filesScrollView;
    _filesScrollView.showsHorizontalScrollIndicator = NO;
    _filesScrollView.backgroundColor=[UIColor whiteColor];
    _filesScrollView.bounces = YES;
    [attaback addSubview:_filesScrollView];
    UITapGestureRecognizer *selectAtta= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectAtta)];
    [_filesScrollView addGestureRecognizer:selectAtta];
    [_filesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attaback).offset(115);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *attaImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fujian_gray"]];
    _attaImage=attaImage;
    [attaback addSubview:_attaImage];
    [_attaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attaback).offset(-30);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImageView *attaRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [attaback addSubview:attaRightImage];
    [attaRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attaback).offset(-10);
        make.centerY.equalTo(attaback);
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
        make.top.equalTo(attaback.mas_bottom).offset(20);
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


#pragma mark - 选择附件
-(void)clickSelectAtta{
    if([self.delegate respondsToSelector:@selector(clickSelectAtta)]){
        [self.delegate clickSelectAtta];
    }
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        switch (textView.tag) {
            case 100:
            {
                textView.text = @"添加谈话事由";
                textView.textColor = [UIColor lightGrayColor];
            }
                break;
            case 101:
            {
                textView.text = @"添加谈话内容";
                textView.textColor = [UIColor lightGrayColor];
            }
                break;
            case 102:
            {
                textView.text = @"添加后续关注措施";
                textView.textColor = [UIColor lightGrayColor];
            }
                break;
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
            if([textView.text isEqualToString:@"添加谈话事由"]){
                textView.text=@"";
                textView.textColor=[UIColor grayColor];
            }
        }
            break;
        case 101:
        {
            if([textView.text isEqualToString:@"添加谈话内容"]){
                textView.text=@"";
                textView.textColor=[UIColor grayColor];
            }
        }
            break;
        case 102:
        {
            if([textView.text isEqualToString:@"添加后续关注措施"]){
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

