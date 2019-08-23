//
//  AddStudentAttentView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddStudentAttentView.h"
#import "DEFINE.h"
@interface AddStudentAttentView ()<UITextViewDelegate>

@end
@implementation AddStudentAttentView


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
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    _timeLabel.text=currentTimeString;
   
}

#pragma mark - initView
- (void)initView{
    
    //学生
    UIButton *nameback=[[UIButton alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    _nameback=nameback;
    _nameback.backgroundColor=[UIColor whiteColor]; 
    [self addSubview:_nameback];
    
    
    //关注时间
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
    talk_timeTitle.text=@"关注时间";
    [timeBack addSubview:talk_timeTitle];
    [talk_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(15);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *timeLabel=[[UILabel alloc] init];
    _timeLabel=timeLabel;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=[UIColor grayColor];
    _timeLabel.textAlignment=NSTextAlignmentRight;
    [timeBack addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBack).offset(115);
        make.centerY.equalTo(timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //关注级别
    UIButton *levelBack=[[UIButton alloc] init];
    levelBack.backgroundColor=[UIColor whiteColor]; 
    [self addSubview:levelBack];
    [levelBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *levelTitle=[[UILabel alloc] init];
    levelTitle.textColor=[UIColor blackColor];
    levelTitle.font=[UIFont systemFontOfSize:14];
    levelTitle.text=@"关注级别";
    [levelBack addSubview:levelTitle];
    [levelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(levelBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UISegmentedControl *levelSegment = [[UISegmentedControl alloc]initWithItems:@[@"一般",@"中度",@"重度"]];
    _levelSegment=levelSegment;
    levelSegment.selectedSegmentIndex=0;
    [levelBack addSubview:_levelSegment];
    [_levelSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(levelBack);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30.0f);
    }];
    
    
    
    //内容
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _commentText.delegate=self;
    _commentText.tag=100;
    [self addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100);
        
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
                textView.text = @"添加内容";
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
            if([textView.text isEqualToString:@"添加内容"]){
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
