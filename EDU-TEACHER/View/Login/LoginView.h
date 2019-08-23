//
//  LoginView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginDelegate <NSObject>
-(void)clickLoginBtnName:(NSString *)username AndPass:(NSString *)password;
-(void)clickRegBtn:(UIButton *)btn;
-(void)clickForgetPassBtn:(UIButton *)btn;
@end


@interface LoginView : UIView
@property(nonatomic,strong)id<LoginDelegate>delegate;

@end


