//
//  ResetPassView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/28.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ResetPassView.h"
#import "DEFINE.h"
@interface ResetPassView ()
@property (nonatomic,strong)UIView *textFiledView;
@property (nonatomic,strong)UITextField * phone;
@property (nonatomic,strong)UITextField * code;
@property (nonatomic,strong)UITextField * password;
@property (nonatomic,strong)UITextField * repassword;
@property (nonatomic,strong)UIButton * codeBtn;
@property (nonatomic,strong)UIButton * submitBtn;
@end
@implementation ResetPassView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        [self initView];
    }
    return self;
}
-(void) initView{
    
    //标题
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(30, 90, kWidth-30*2, 40)];
    title.text=@"密码找回";
    title.font=[UIFont systemFontOfSize:22];
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentLeft;
    [self addSubview:title];
    
    //输入框背景
    UIView *textFiledView = [[UIView alloc]init];
    _textFiledView=textFiledView;
    _textFiledView.frame = CGRectMake(30, 150, kWidth-30*2, 55*4);
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
    NSArray *iconArray=@[@"shoujihao",@"yanzhengma",@"mimaxianshi",@"zaicishuru"];
    for(int i=0;i<4;i++){
        if(i!=3){
            UIView * line=[[UIView alloc] initWithFrame:CGRectMake(10, (50+5)*(i+1), kWidth-10*2-30*2, 1)];
            line.backgroundColor=GKColorHEX(0xeeeeee, 1);
            [_textFiledView addSubview: line];
        }
        UIView * hline=[[UIView alloc] initWithFrame:CGRectMake(55, 55*i+15, 1, 25)];
        hline.backgroundColor=GKColorHEX(0xeeeeee, 1);
        [_textFiledView addSubview: hline];
        
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
        iconImageView.image = [UIImage imageNamed:[iconArray objectAtIndex:i]];
        [_textFiledView addSubview: iconImageView];
        
        
    }
    
    
    //用户名密码
    [_textFiledView addSubview:self.phone];
    [_textFiledView addSubview:self.code];
    [_textFiledView addSubview:self.password];
    [_textFiledView addSubview:self.repassword];
    [_textFiledView addSubview:self.codeBtn];
    [self addSubview:self.submitBtn];
    
}

#pragma mark - 懒加载

- (UITextField *)phone{
    if (!_phone) {
        _phone=[[UITextField alloc] init];
        _phone.backgroundColor=[UIColor clearColor];
        _phone.font=[UIFont systemFontOfSize:16];
        _phone.textColor=[UIColor darkGrayColor];
        _phone.keyboardType=UIKeyboardTypeNumberPad;
        _phone.frame=CGRectMake(70, 55*0+15, kWidth-30*2-80, 30);
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
        _code.frame=CGRectMake(70, 55*1+15, kWidth-30*2-80-100, 30);
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
        _password.frame=CGRectMake(70, 55*2+15, kWidth-30*2-80, 30);
        _password.placeholder=@"密码";
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
        _repassword.frame=CGRectMake(70, 55*3+15, kWidth-30*2-80, 30);
        _repassword.placeholder=@"再次输入密码";
    }
    return _repassword;
}
- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth-175, 55*1+15, 100, 30)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _codeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_codeBtn addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _codeBtn;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, 405, kWidth-40*2, 40)];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _submitBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius=16;
        _submitBtn.layer.masksToBounds=YES;
        _submitBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _submitBtn;
}

-(void)clickCodeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickCodeBtn:phone:)]){
        [self.delegate clickCodeBtn:sender phone:_phone.text];
    }
}
-(void)clickSubmitBtn:(UIButton *)sender{
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:_phone.text forKey:@"phone"];
    [paramDic setObject:_code.text forKey:@"code"];
    [paramDic setObject:_password.text forKey:@"password"];
    [paramDic setObject:_repassword.text forKey:@"repassword"];
    if([self.delegate respondsToSelector:@selector(clickSubmitBtn:paramDic:)]){
        [self.delegate clickSubmitBtn:sender paramDic:paramDic];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


@end
