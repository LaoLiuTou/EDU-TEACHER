//
//  LoginView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LoginView.h"
#import "DEFINE.h"
@interface LoginView ()
@property (nonatomic,strong)UIView *textFiledView;
@property (nonatomic,strong)UITextField * username;
@property (nonatomic,strong)UITextField * password;
@property (nonatomic,strong)UIButton * loginBtn;
@property (nonatomic,strong)UIButton *regbtn;
@property (nonatomic,strong)UIButton *forgetPassBtn;
@property (nonatomic,strong)UIButton *seePassBtn;
@end


@implementation LoginView
#pragma mark 刷新界面
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight); 
        [self initView];
    }
    return self;
}
-(void) initView{
    //注册
    UIButton *regbtn=[[UIButton alloc] initWithFrame:CGRectMake(28, 30, kWidth-28*2, 30)];
    _regbtn=regbtn;
    [_regbtn setTitle:@"账号申请" forState:UIControlStateNormal];
    _regbtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_regbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_regbtn addTarget:self action:@selector(clickRegBtn:) forControlEvents:UIControlEventTouchUpInside];
    _regbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:_regbtn];
    //标题
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(30, 90, kWidth-30*2, 40)];
    title.text=@"在校园";
    title.font=[UIFont systemFontOfSize:22];
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentLeft;
    [self addSubview:title];
    //描述
    UILabel *detail=[[UILabel alloc] initWithFrame:CGRectMake(30, 140, kWidth-30*2, 40)];
    detail.text=@"基于过程育人的学生系统管理";
    detail.font=[UIFont systemFontOfSize:22];
    detail.textColor=[UIColor blackColor];
    detail.textAlignment=NSTextAlignmentLeft;
    [self addSubview:detail];
    //输入框背景
    UIView *textFiledView = [[UIView alloc]init];
    _textFiledView=textFiledView;
    _textFiledView.frame = CGRectMake(30, 220, kWidth-30*2, 110);
    _textFiledView.backgroundColor = [UIColor whiteColor];
    _textFiledView.layer.shadowColor = [UIColor blackColor].CGColor;
    _textFiledView.layer.shadowOffset = CGSizeMake(0,0);
    _textFiledView.layer.shadowOpacity = 0.2;
    _textFiledView.layer.shadowRadius = 4;
    _textFiledView.layer.cornerRadius = 4;
    _textFiledView.layer.masksToBounds = YES;
    _textFiledView.clipsToBounds = NO;
    [self addSubview:_textFiledView];
    UIView * line=[[UIView alloc] initWithFrame:CGRectMake(10, 55, kWidth-10*2-30*2, 1)];
    line.backgroundColor=GKColorHEX(0xeeeeee, 1);
    UIView * hline1=[[UIView alloc] initWithFrame:CGRectMake(55, 15, 1, 25)];
    hline1.backgroundColor=GKColorHEX(0xeeeeee, 1);
    UIView * hline2=[[UIView alloc] initWithFrame:CGRectMake(55, 70, 1, 25)];
    hline2.backgroundColor=GKColorHEX(0xeeeeee, 1);
    
    //不用leftView
    UIImageView *nameImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 29, 29)];
    nameImage.image = [UIImage imageNamed:@"renshu"];
    UIButton *seePassBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, 55+13, 29, 29)];
    _seePassBtn=seePassBtn;
    [_seePassBtn setBackgroundImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
    [_seePassBtn addTarget:self action:@selector(clickSeePassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_textFiledView addSubview: line];
    [_textFiledView addSubview: hline1];
    [_textFiledView addSubview: hline2];
    [_textFiledView addSubview: nameImage];
    [_textFiledView addSubview: _seePassBtn];
    //忘记密码
    NSString * forgetString = @"忘记登录密码？找回密码";
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",forgetString]];
    //[tempStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0,7)];
    [tempStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,7)];
    UIButton *forgetPassBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 410, kWidth, 30)];
    _forgetPassBtn=forgetPassBtn;
    [_forgetPassBtn setAttributedTitle:tempStr forState:UIControlStateNormal];
    _forgetPassBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_forgetPassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forgetPassBtn addTarget:self action:@selector(clickForgetPassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_forgetPassBtn];
    
    //用户名密码
    [_textFiledView addSubview:self.username];
    [_textFiledView addSubview:self.password];
    [self addSubview:self.loginBtn];
    
    //
    //_username.text=@"18584323528";
    //_password.text=@"000000";
}

#pragma mark - 懒加载 
- (UITextField *)username{
    if (!_username) {
        _username=[[UITextField alloc] init];
        _username.backgroundColor=[UIColor clearColor];
        _username.font=[UIFont systemFontOfSize:16];
        _username.textColor=[UIColor darkGrayColor];
        _username.frame=CGRectMake(70, 15, kWidth-30*2-80, 30);
        _username.placeholder=@"账号";
    }
    return _username;
}
- (UITextField *)password{
    if (!_password) {
        _password=[[UITextField alloc] init];
        [_password  setSecureTextEntry:YES];
        _password.backgroundColor=[UIColor clearColor];
        _password.font=[UIFont systemFontOfSize:16];
        _password.textColor=[UIColor darkGrayColor];
        _password.frame=CGRectMake(70, 70, kWidth-30*2-80, 30);
        _password.placeholder=@"密码";
    }
    return _password;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, 360, kWidth-40*2, 40)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _loginBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius=16;
        _loginBtn.layer.masksToBounds=YES;
        _loginBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginBtn;
}

-(void)clickSeePassBtn:(UIButton *)sender{
    
    NSString *tempPwdStr = _password.text;
    _password.text = @""; // 这句代码可以防止切换的时候光标偏移
    _password.secureTextEntry = NO;
    _password.text = tempPwdStr;
    [_seePassBtn setBackgroundImage:[UIImage imageNamed:@"mimaxianshi"] forState:UIControlStateNormal];
    [_seePassBtn addTarget:self action:@selector(clickHidePassBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickHidePassBtn:(UIButton *)sender{
    NSString *tempPwdStr = _password.text;
    _password.text = @"";
    _password.secureTextEntry = YES;
    _password.text = tempPwdStr;
    [_seePassBtn setBackgroundImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
    [_seePassBtn addTarget:self action:@selector(clickSeePassBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickLoginBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickLoginBtnName:AndPass:)]){
        [self.delegate clickLoginBtnName:_username.text AndPass:_password.text];
    }
}
-(void)clickRegBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickRegBtn:)]){
        [self.delegate clickRegBtn:sender];
    }
}
-(void)clickForgetPassBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickForgetPassBtn:)]){
        [self.delegate clickForgetPassBtn:sender];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
