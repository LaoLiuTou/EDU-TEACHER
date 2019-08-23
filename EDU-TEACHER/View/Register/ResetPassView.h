//
//  ResetPassView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/28.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@protocol ResetPassDelegate <NSObject>
-(void)clickSubmitBtn:(UIButton *)btn paramDic:(NSDictionary *)paramDic;
-(void)clickCodeBtn:(UIButton *)btn phone:(NSString *)phone;
@end

@interface ResetPassView : UIView
@property(nonatomic,strong)id<ResetPassDelegate>delegate;
@end

