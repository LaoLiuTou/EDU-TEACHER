//
//  ChangePasswordView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ChangePasswordView.h"
#import "DEFINE.h"
@interface ChangePasswordView ()
@property (nonatomic,strong)UIView *textFiledView;

@property (nonatomic,strong)UIButton * changeBtn;
@end

@implementation ChangePasswordView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        [self initView];
       
    }
    return self;
}
-(void) initView{
    
 
    //输入框背景
    UIView *textFiledView = [[UIView alloc]init];
    _textFiledView=textFiledView;
    _textFiledView.frame = CGRectMake(0, 6, kWidth, 55*3);
    _textFiledView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_textFiledView];
    
    //图标 and 线
    NSArray *iconArray=@[@"zaicishuru",@"zaicishuru",@"zaicishuru"];
    for(int i=0;i<3;i++){
        
        UIView * line=[[UIView alloc] initWithFrame:CGRectMake(0, (50+5)*(i+1), kWidth, 1)];
        line.backgroundColor=GKColorHEX(0xeeeeee, 1);
        [_textFiledView addSubview: line];
        
        UIView * hline=[[UIView alloc] initWithFrame:CGRectMake(55, 55*i+15, 1, 25)];
        hline.backgroundColor=GKColorHEX(0xeeeeee, 1);
        [_textFiledView addSubview: hline];
        
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
        iconImageView.image = [UIImage imageNamed:[iconArray objectAtIndex:i]];
        [_textFiledView addSubview: iconImageView];
        
        
    }
    
    
    [_textFiledView addSubview:self.oldPassword];
    [_textFiledView addSubview:self.password];
    [_textFiledView addSubview:self.repassword];
    [self addSubview:self.changeBtn];
    
}

- (UITextField *)oldPassword{
    if (!_oldPassword) {
        _oldPassword=[[UITextField alloc] init];
        [_oldPassword  setSecureTextEntry:YES];
        _oldPassword.backgroundColor=[UIColor clearColor];
        _oldPassword.font=[UIFont systemFontOfSize:16];
        _oldPassword.textColor=[UIColor darkGrayColor];
        _oldPassword.frame=CGRectMake(70, 15, kWidth-30-80, 30);
        _oldPassword.placeholder=@"旧密码";
    }
    return _oldPassword;
}
- (UITextField *)password{
    if (!_password) {
        _password=[[UITextField alloc] init];
        [_password  setSecureTextEntry:YES];
        _password.backgroundColor=[UIColor clearColor];
        _password.font=[UIFont systemFontOfSize:16];
        _password.textColor=[UIColor darkGrayColor];
        _password.frame=CGRectMake(70, 55+15, kWidth-30-80, 30);
        _password.placeholder=@"新密码";
    }
    return _password;
}
- (UITextField *)repassword{
    if (!_repassword) {
        _repassword=[[UITextField alloc] init];
        [_repassword  setSecureTextEntry:YES];
        _repassword.backgroundColor=[UIColor clearColor];
        _repassword.font=[UIFont systemFontOfSize:16];
        _repassword.textColor=[UIColor darkGrayColor];
        _repassword.frame=CGRectMake(70, 55*2+15, kWidth-30-80, 30);
        _repassword.placeholder=@"确认新密码";
    }
    return _repassword;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(60, 220, kWidth-60*2, 40)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _changeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_changeBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:@"确定" forState:UIControlStateNormal];
        _changeBtn.layer.cornerRadius=16;
        _changeBtn.layer.masksToBounds=YES;
        _changeBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _changeBtn;
}


-(void)clickChangeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickChangeBtn:)]){
        [self.delegate clickChangeBtn:sender];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}



@end
