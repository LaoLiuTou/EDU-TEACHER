//
//  VerifyUtil.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/28.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "VerifyUtil.h"

@implementation VerifyUtil



+ (BOOL) checkEmpty:(UITextField *) textField {
    return [VerifyUtil checkEmptyString:textField.text];
}

+ (BOOL) checkEmptyString:(NSString *) string {
    
    if (string == nil) return string == nil;
    
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}


+ (BOOL) checkMobileNo:(UITextField *)textField {
    
    return [VerifyUtil isVaildMobileNo:textField.text];
}

+ (BOOL) isVaildMobileNo:(NSString *)mobileNo
{
    if ([VerifyUtil checkEmptyString:mobileNo]) return NO;
    
    NSString *phoneRegex = @"^((1[3456789]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNo];
}

+ (BOOL) checkEmail:(UITextField *)textField {
    
    return [VerifyUtil isValidEmail:textField.text];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    if ([VerifyUtil checkEmptyString:checkString]) return NO;
    
    NSString *emailRegex = @"^(([a-zA-Z0-9_-]+)|([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)))@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL) checkBankCard: (UITextField *)textField {
    
    return [VerifyUtil isVaildBankCard:textField.text];
}

+ (BOOL) isVaildBankCard:(NSString *)bankCardNo {
    
    if ([VerifyUtil checkEmptyString:bankCardNo]) return NO;
    
    NSString *judgeStr = [bankCardNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [judgeStr length] >= 12 && [judgeStr length] <= 19;     //银行卡号一定是大于等于12位小于等于19位的数字
}


// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)checkIDCardNum:(UITextField *)textField
{
    return [VerifyUtil isVaildIDCardNo:textField.text];
}

// 身份证号码校验 （仅允许  数字 ||  Xx）
+ (BOOL)isVaildIDCardNo:(NSString *)idCardNo
{
    if ([VerifyUtil checkEmptyString:idCardNo]) return NO;
    
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardNo];
    if (!isRe) {
        //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardNo substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardNo.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}


+ (BOOL)checkRealName:(UITextField *)textField
{
    return [VerifyUtil isVaildRealName:textField.text];
}

// 姓名校验 2~8个中文字,不允许拼音,数字
+ (BOOL)isVaildRealName:(NSString *)realName
{
    if ([VerifyUtil checkEmptyString:realName]) return NO;
    
    NSRange range1 = [realName rangeOfString:@"·"];
    NSRange range2 = [realName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 8) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}
@end
