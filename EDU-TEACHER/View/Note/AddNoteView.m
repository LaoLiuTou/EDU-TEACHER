//
//  AddNoteView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddNoteView.h"
#import "DEFINE.h"

@interface AddNoteView ()<UITextViewDelegate>

@end

@implementation AddNoteView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        //[self initView];
    }
    return self;
}
#pragma mark - initView
- (int)initView{
    
    //标题
//    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
//    nameback.backgroundColor=[UIColor whiteColor];
//    [self addSubview:nameback];
//
//    UITextField *nameText=[[UITextField alloc] init];
//    _nameText=nameText;
//    _nameText.backgroundColor=[UIColor whiteColor];
//    _nameText.font=[UIFont systemFontOfSize:14];
//    _nameText.textColor=[UIColor darkGrayColor];
//    _nameText.placeholder=@"添加日志名称";
//    [self addSubview:_nameText];
//    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.top.equalTo(self).offset(6);
//        make.width.mas_equalTo(kWidth-30);
//        make.height.mas_equalTo(50.0f);
//    }];
    
    //关注级别
    /*
    UIButton *typeBack=[[UIButton alloc] init];
    typeBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:typeBack];
    [typeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *levelTitle=[[UILabel alloc] init];
    levelTitle.textColor=[UIColor blackColor];
    levelTitle.font=[UIFont systemFontOfSize:14];
    levelTitle.text=@"日志类型";
    [typeBack addSubview:levelTitle];
    [levelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeBack).offset(15);
        make.centerY.equalTo(typeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UISegmentedControl *typeSegment = [[UISegmentedControl alloc]initWithItems:@[@"日常管理",@"谈心谈话"]];
    //[typeSegment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    _typeSegment=typeSegment;
    _typeSegment.selectedSegmentIndex=0;
    [typeBack addSubview:_typeSegment];
    [_typeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(typeBack).offset(-15);
        make.centerY.equalTo(typeBack);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30.0f);
    }];
    */
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(220);
    }];
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加日志内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.delegate=self;
    [commentback addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(200);
    }];
    
    //选择签到范围
     
     UIButton *selectback=[[UIButton alloc] init];
     selectback.backgroundColor=[UIColor whiteColor];
     [selectback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:selectback];
     [selectback mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(commentback.mas_bottom).offset(6);
         make.width.mas_equalTo(kWidth);
         make.height.mas_equalTo(50);
     }];
     UILabel *selectLabel=[[UILabel alloc] init];
     selectLabel.text=@"相关学生";
     selectLabel.font=[UIFont systemFontOfSize:14];
     selectLabel.textColor=[UIColor blackColor];
     selectLabel.textAlignment=NSTextAlignmentLeft;
     [selectback addSubview:selectLabel];
     [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(selectback).offset(15);
         make.centerY.equalTo(selectback);
         make.width.mas_equalTo(100);
         make.height.mas_equalTo(50);
     }];
    UIScrollView *stuScrollView=[[UIScrollView alloc] init];
    _stuScrollView=stuScrollView;
    _stuScrollView.showsHorizontalScrollIndicator = NO;
    _stuScrollView.backgroundColor=[UIColor whiteColor];
    _stuScrollView.bounces = YES;
    [selectback addSubview:_stuScrollView];
    UITapGestureRecognizer *selectStu= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectStu)];
    [_stuScrollView addGestureRecognizer:selectStu];
    [_stuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectback).offset(115);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *selectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
    _selectImage=selectImage;
    [selectback addSubview:_selectImage];
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectback).offset(-30);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
     UIImageView *selectRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
     [selectback addSubview:selectRightImage];
     [selectRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(selectback).offset(-10);
         make.centerY.equalTo(selectback);
         make.width.mas_equalTo(24);
         make.height.mas_equalTo(24);
     }];
    
    return 350;
}


#pragma mark - 选择人员
-(void)clickSelectStu{
    if([self.delegate respondsToSelector:@selector(clickSelectStu)]){
        [self.delegate clickSelectStu];
    }
}
#pragma mark - 发布
-(void)clickSaveBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSaveBtn:)]){
        [self.delegate clickSaveBtn:sender];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.commentText.text = @"添加日志内容";
        self.commentText.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.commentText.text isEqualToString:@"添加日志内容"]){
        self.commentText.text=@"";
        self.commentText.textColor=[UIColor darkGrayColor];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
