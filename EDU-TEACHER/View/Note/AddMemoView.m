//
//  AddMemoView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddMemoView.h" 
#import "DEFINE.h"

@interface AddMemoView ()<UITextViewDelegate>

@end 

@implementation AddMemoView

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
    self.selectType=@"-1";
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
//    _nameText.placeholder=@"添加备忘名称";
//    [self addSubview:_nameText];
//    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.top.equalTo(self).offset(6);
//        make.width.mas_equalTo(kWidth-30);
//        make.height.mas_equalTo(50.0f);
//    }];
    
    
    //级别
    UIButton *levelBack=[[UIButton alloc] init];
    levelBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:levelBack];
    [levelBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(106.0f);
    }];
    NSArray *titleArray=@[@"重要紧急",@"重要不紧急",@"紧急不重要",@"不重要不紧急"];
    for(int i=0;i<4;i++){
        UIButton *tempBtn = [UIButton new];
        tempBtn.tag=1000+(3-i);
        [tempBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.backgroundColor=[UIColor whiteColor];
        [tempBtn.layer setMasksToBounds:YES];
        [tempBtn.layer setCornerRadius:8.0];
        [tempBtn.layer setBorderWidth:1.0];
        tempBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        tempBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [tempBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [levelBack addSubview:tempBtn];
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(levelBack).offset(9 +50*(int)(i/2));
            make.left.equalTo(levelBack).offset(15 +(kWidth/2)*(i%2));
            make.width.mas_equalTo((kWidth-60)/2);
            make.height.mas_equalTo(36.0f);
        }];
        
        UIView *leftview=[[UIView alloc] init];
        leftview.backgroundColor=[UIColor lightGrayColor];
        leftview.tag=10000+(3-i);
        [levelBack addSubview:leftview];
        [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(levelBack).offset(17 +50*(int)(i/2));
            make.left.equalTo(levelBack).offset(30 +(kWidth/2)*(i%2));
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(20);
        }];
        
        
        if(i==0){
            self.selectType= [NSString stringWithFormat:@"%d",(3-i)];
            [tempBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            tempBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
            leftview.backgroundColor=GKColorRGB(234, 37, 0);
        }
        
       
    }
    
    
    //类型
//    UIButton *typeBack=[[UIButton alloc] init];
//    typeBack.backgroundColor=[UIColor whiteColor];
//    [self addSubview:typeBack];
//    [typeBack mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(levelBack.mas_bottom).offset(1);
//        make.width.mas_equalTo(kWidth);
//        make.height.mas_equalTo(50.0f);
//    }];
//    UILabel *levelTitle=[[UILabel alloc] init];
//    levelTitle.textColor=[UIColor blackColor];
//    levelTitle.font=[UIFont systemFontOfSize:14];
//    levelTitle.text=@"备忘类型";
//    [typeBack addSubview:levelTitle];
//    [levelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(typeBack).offset(15);
//        make.centerY.equalTo(typeBack);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(50.0f);
//    }];
//    UISegmentedControl *typeSegment = [[UISegmentedControl alloc]initWithItems:@[@"日常管理",@"谈心谈话"]];
//    //[typeSegment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
//    _typeSegment=typeSegment;
//    _typeSegment.selectedSegmentIndex=0;
//    [typeBack addSubview:_typeSegment];
//    [_typeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(typeBack).offset(-15);
//        make.centerY.equalTo(typeBack);
//        make.width.mas_equalTo(140);
//        make.height.mas_equalTo(30.0f);
//    }];
    
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelBack.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(220);
    }];
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加备忘内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.delegate=self;
    [commentback addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(200);
    }];
    
    
    //提醒日期
    UIButton *c_timeBack=[[UIButton alloc] init];
    c_timeBack.backgroundColor=[UIColor whiteColor];
    c_timeBack.tag=101;
    [c_timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:c_timeBack];
    [c_timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *c_timeTitle=[[UILabel alloc] init];
    c_timeTitle.textColor=[UIColor blackColor];
    c_timeTitle.font=[UIFont systemFontOfSize:14];
    c_timeTitle.text=@"提醒日期";
    [c_timeBack addSubview:c_timeTitle];
    [c_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(c_timeBack).offset(15);
        make.centerY.equalTo(c_timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *c_timeLabel=[[UILabel alloc] init];
    _timeLabel=c_timeLabel;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=[UIColor darkGrayColor];
    _timeLabel.textAlignment=NSTextAlignmentRight;
    _timeLabel.text=@"";
    [c_timeBack addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(c_timeBack).offset(115);
        make.centerY.equalTo(c_timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //选择签到范围
    
    UIButton *selectback=[[UIButton alloc] init];
    selectback.backgroundColor=[UIColor whiteColor];
    [selectback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectback];
    [selectback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(c_timeBack.mas_bottom).offset(1);
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
    
    return 500;
}

#pragma mark - 类型
-(void)clickTypeBtn:(UIButton *)sender{
    int btnTag=sender.tag%1000;
    self.selectType= [NSString stringWithFormat:@"%d",btnTag];
    NSArray *colorArray=@[GKColorRGB(108, 180, 24),GKColorRGB(0, 200, 199),GKColorRGB(242, 164, 0),GKColorRGB(234, 37, 0)];
    for(int i=0;i<4;i++){
        UIView *leftView = [self viewWithTag:10000+i];
        leftView.backgroundColor=[UIColor lightGrayColor];
        UIButton *tempBtn =[self viewWithTag:1000+i];
        [tempBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         tempBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    } 
    [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     sender.layer.borderColor=[UIColor darkGrayColor].CGColor;
    
    UIView *leftView = [self viewWithTag:10000+btnTag];
    leftView.backgroundColor=colorArray[btnTag];
    if([self.delegate respondsToSelector:@selector(clickTypeBtn:)]){
        [self.delegate clickTypeBtn:sender];
    }
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
#pragma mark - 时间
-(void)clickTimeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickTimeBtn:)]){
        [self.delegate clickTimeBtn:sender];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.commentText.text = @"添加备忘内容";
        self.commentText.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.commentText.text isEqualToString:@"添加备忘内容"]){
        self.commentText.text=@"";
        self.commentText.textColor=[UIColor darkGrayColor];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end

