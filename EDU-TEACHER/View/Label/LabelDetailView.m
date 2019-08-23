//
//  LabelDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LabelDetailView.h"
#import "DEFINE.h"
@implementation LabelDetailView
{
    int viewHeight;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(LabelModel *)labelModel{
    self.labelModel=labelModel;
    [self initView];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    UITextField *nameLabel=[[UITextField alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =self.labelModel.tag_name;
    [nameback addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(25);
       make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    viewHeight=56;
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    UIFont *font=[UIFont systemFontOfSize:14];
    //内容
    UILabel *commentTitleLabel=[[UILabel alloc] init];
    commentTitleLabel.backgroundColor=[UIColor whiteColor];
    commentTitleLabel.font=[UIFont systemFontOfSize:16];
    commentTitleLabel.text=@"标签说明：";
    commentTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitleLabel];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *comment=self.labelModel.remark;
    //CGFloat commentHeight = [comment boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    UITextView *remarkLabel=[[UITextView alloc] init];
    _remarkLabel=remarkLabel;
    _remarkLabel.backgroundColor=[UIColor whiteColor];
    _remarkLabel.font=[UIFont systemFontOfSize:14];
    _remarkLabel.text =comment;
    _remarkLabel.textColor =[UIColor grayColor];
    [_remarkLabel setTextAlignment:NSTextAlignmentLeft]; 
    [_remarkLabel sizeToFit];
    [commentback addSubview:_remarkLabel];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(80);
    }];
    viewHeight=viewHeight+100+50;
    
    
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100+50);
    }];
    
    
    //add
    UIButton *addStuBack=[[UIButton alloc] init];
    addStuBack.backgroundColor=[UIColor whiteColor];
    [addStuBack addTarget:self action:@selector(clickSelectStuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addStuBack];
    UIImageView *addImage=[[UIImageView alloc] init];
    [addImage setImage:[UIImage imageNamed:@"jiahao"]];
    [addStuBack addSubview:addImage];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addStuBack).offset(15);
        make.centerY.equalTo(addStuBack);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    UILabel *addLabel=[[UILabel alloc] init];
    addLabel.backgroundColor=[UIColor whiteColor];
    addLabel.font=[UIFont systemFontOfSize:16];
    addLabel.textColor=[UIColor blackColor];
    addLabel.text =@"添加标签对象";
    [addStuBack addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addStuBack).offset(44);
        make.centerY.equalTo(addStuBack);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(50.0f);
    }];
    [addStuBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }]; 
    
    viewHeight=viewHeight+56;
    
    
}
#pragma mark - 选择人员
-(void)clickSelectStuBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSelectStuBtn:)]){
        [self.delegate clickSelectStuBtn:sender];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
