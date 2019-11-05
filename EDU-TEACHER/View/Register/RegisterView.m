//
//  RegisterView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "RegisterView.h"
#import "DEFINE.h"

@interface RegisterView ()
@property (nonatomic,strong)UIView *textFiledView;
@property (nonatomic,strong)UITextField * username;
@property (nonatomic,strong)UITextField * phone;
@property (nonatomic,strong)UITextField * code;
@property (nonatomic,strong)UITextField * password;
@property (nonatomic,strong)UITextField * repassword;
@property (nonatomic,strong)UIButton * codeBtn;
@property (nonatomic,strong)UIButton * nextBtn;
@property (nonatomic,strong)RegisterModel *registerModel;

@property (nonatomic,strong)UIButton *seePassBtn;
@property (nonatomic,strong)UIButton *seeRePassBtn;
@end

@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        [self initView];
        _registerModel = [[RegisterModel alloc] init];
    }
    return self;
}
-(void) initView{
    
    //标题
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(30, 90, kWidth-30*2, 40)];
    title.text=@"账号申请";
    title.font=[UIFont systemFontOfSize:22];
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentLeft;
    [self addSubview:title];
    
    //输入框背景
    UIView *textFiledView = [[UIView alloc]init];
    _textFiledView=textFiledView;
    _textFiledView.frame = CGRectMake(30, 150, kWidth-30*2, 55*5);
    _textFiledView.backgroundColor = [UIColor whiteColor];
    _textFiledView.layer.shadowColor = [UIColor blackColor].CGColor;
    _textFiledView.layer.shadowOffset = CGSizeMake(0,0);
    _textFiledView.layer.shadowOpacity = 0.2;
    _textFiledView.layer.shadowRadius = 4;
    _textFiledView.layer.cornerRadius = 4;
    _textFiledView.layer.masksToBounds = YES;
    _textFiledView.clipsToBounds = NO;
    [self addSubview:_textFiledView];
    
    //图标 and 线
    NSArray *iconArray=@[@"zhenshixingming",@"shoujihao",@"yanzhengma",@"mimaxianshi",@"zaicishuru"];
    for(int i=0;i<5;i++){
        if(i!=4){
            UIView * line=[[UIView alloc] initWithFrame:CGRectMake(10, (50+5)*(i+1), kWidth-10*2-30*2, 1)];
            line.backgroundColor=GKColorHEX(0xeeeeee, 1);
            [_textFiledView addSubview: line];
        }
        UIView * hline=[[UIView alloc] initWithFrame:CGRectMake(55, 55*i+15, 1, 25)];
        hline.backgroundColor=GKColorHEX(0xeeeeee, 1);
        [_textFiledView addSubview: hline];
        
        if(i==3){
            UIButton *seePassBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
            _seePassBtn=seePassBtn;
            [_seePassBtn setBackgroundImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
            [_seePassBtn addTarget:self action:@selector(clickSeePassBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_textFiledView addSubview: _seePassBtn];
        }
        else if(i==4){
            UIButton *seeRePassBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
            _seeRePassBtn=seeRePassBtn;
            [_seeRePassBtn setBackgroundImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
            [_seeRePassBtn addTarget:self action:@selector(clickSeeRePassBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_textFiledView addSubview: _seeRePassBtn];
        }
        else{
            UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
            iconImageView.image = [UIImage imageNamed:[iconArray objectAtIndex:i]];
            [_textFiledView addSubview: iconImageView];
        }
        
        
        
    }
    
    
    
    //用户名密码
    [_textFiledView addSubview:self.username];
    [_textFiledView addSubview:self.phone];
    [_textFiledView addSubview:self.code];
    [_textFiledView addSubview:self.password];
    [_textFiledView addSubview:self.repassword];
    [_textFiledView addSubview:self.codeBtn];
    [self addSubview:self.nextBtn];
    
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

-(void)clickSeeRePassBtn:(UIButton *)sender{
    
    NSString *tempPwdStr = _repassword.text;
    _repassword.text = @""; // 这句代码可以防止切换的时候光标偏移
    _repassword.secureTextEntry = NO;
    _repassword.text = tempPwdStr;
    [_seeRePassBtn setBackgroundImage:[UIImage imageNamed:@"mimaxianshi"] forState:UIControlStateNormal];
    [_seeRePassBtn addTarget:self action:@selector(clickHideRePassBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickHideRePassBtn:(UIButton *)sender{
    NSString *tempPwdStr = _repassword.text;
    _repassword.text = @"";
    _repassword.secureTextEntry = YES;
    _repassword.text = tempPwdStr;
    [_seeRePassBtn setBackgroundImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
    [_seeRePassBtn addTarget:self action:@selector(clickSeeRePassBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 懒加载
- (UITextField *)username{
    if (!_username) {
        _username=[[UITextField alloc] init];
        _username.backgroundColor=[UIColor clearColor];
        _username.font=[UIFont systemFontOfSize:16];
        _username.textColor=[UIColor darkGrayColor];
        _username.frame=CGRectMake(70, 15, kWidth-30*2-80, 30);
        _username.placeholder=@"真实姓名"; 
    }
    return _username;
}
- (UITextField *)phone{
    if (!_phone) {
        _phone=[[UITextField alloc] init];
        _phone.backgroundColor=[UIColor clearColor];
        _phone.font=[UIFont systemFontOfSize:16];
        _phone.textColor=[UIColor darkGrayColor];
        _phone.keyboardType=UIKeyboardTypeNumberPad;
        _phone.frame=CGRectMake(70, 55*1+15, kWidth-30*2-80, 30);
        _phone.placeholder=@"手机号";
    }
    return _phone;
}
- (UITextField *)code{
    if (!_code) {
        _code=[[UITextField alloc] init];
        _code.backgroundColor=[UIColor clearColor];
        _code.font=[UIFont systemFontOfSize:16];
        _code.textColor=[UIColor darkGrayColor];
        _code.keyboardType=UIKeyboardTypeNumberPad;
        _code.frame=CGRectMake(70, 55*2+15, kWidth-30*2-80-100, 30);
        _code.placeholder=@"验证码";
    }
    return _code;
}
- (UITextField *)password{
    if (!_password) {
        _password=[[UITextField alloc] init];
        [_password  setSecureTextEntry:YES];
        _password.backgroundColor=[UIColor clearColor];
        _password.font=[UIFont systemFontOfSize:16];
        _password.textColor=[UIColor darkGrayColor];
        _password.frame=CGRectMake(70, 55*3+15, kWidth-30*2-80, 30);
        _password.placeholder=@"密码为8-16位数字与字母组合";
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
        _repassword.frame=CGRectMake(70, 55*4+15, kWidth-30*2-80, 30);
        _repassword.placeholder=@"再次输入密码";
    }
    return _repassword;
}
- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth-175, 55*2+15, 100, 30)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _codeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_codeBtn addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _codeBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, 460, kWidth-40*2, 40)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _nextBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius=16;
        _nextBtn.layer.masksToBounds=YES;
        _nextBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

-(void)clickCodeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickCodeBtn:phone:)]){
        [self.delegate clickCodeBtn:sender phone:_phone.text];
    }
}
-(void)clickNextBtn:(UIButton *)sender{
    self.registerModel.username=_username.text;
    self.registerModel.phone=_phone.text;
    self.registerModel.code=_code.text;
    self.registerModel.password=_password.text;
    self.registerModel.repassword=_repassword.text;
    
    if([self.delegate respondsToSelector:@selector(clickNextBtn:registerModel:)]){
        [self.delegate clickNextBtn:sender registerModel:self.registerModel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}



@end
