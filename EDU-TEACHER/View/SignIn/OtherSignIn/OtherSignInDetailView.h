//
//  OtherSignInDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "OtherSignInModel.h"

@interface OtherSignInDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *commentLabel;//内容
@property (nonatomic,strong) UIImageView *fujianIcon;
@property (nonatomic,strong) OtherSignInModel *otherSignInModel;
-(int)initModel:(OtherSignInModel *) model;
@end
