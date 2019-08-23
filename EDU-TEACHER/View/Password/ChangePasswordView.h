//
//  ChangePasswordView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePassDelegate <NSObject>
-(void)clickChangeBtn:(UIButton *)btn; 
@end
@interface ChangePasswordView : UIView
@property (nonatomic,strong)UITextField * oldPassword;
@property (nonatomic,strong)UITextField * password;
@property (nonatomic,strong)UITextField * repassword;
@property(nonatomic,strong)id<ChangePassDelegate>delegate;
@end
 
