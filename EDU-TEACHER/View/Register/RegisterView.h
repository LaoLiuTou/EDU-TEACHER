//
//  RegisterView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"
@protocol RegisterDelegate <NSObject>
-(void)clickNextBtn:(UIButton *)btn registerModel:(RegisterModel *)registerModel;
-(void)clickCodeBtn:(UIButton *)btn phone:(NSString *)phone;
@end


@interface RegisterView : UIView
@property(nonatomic,strong)id<RegisterDelegate>delegate;
@end


