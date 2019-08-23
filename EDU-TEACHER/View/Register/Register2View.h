//
//  Register2View.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"
@protocol Register2Delegate <NSObject> 
-(void)clickRegBtn:(UIButton *)btn registerModel:(RegisterModel *)registerModel;
@end

@interface Register2View : UIView
@property(nonatomic,strong)id<Register2Delegate>delegate;
@property (nonatomic,strong)RegisterModel *registerModel;
@end

