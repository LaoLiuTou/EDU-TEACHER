//
//  SignInListCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInModel.h"
@protocol SignInCellDelegate <NSObject>
-(void)clickStatusBtn:(UIButton *)btn signin:(SignInModel *) signin;
@end


@interface SignInListCell : UITableViewCell

@property (nonatomic,strong) UILabel *typeLabel;//类型
@property (nonatomic,strong) UILabel *nameLabel;//名称
@property (nonatomic,strong) UILabel *start_timeLabel;//开始时间
@property (nonatomic,strong) UILabel *end_timeLabel;//结束时间
@property (nonatomic,strong) UIButton *statusButton;//状态
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) SignInModel *signin;//通知
- (void)initView:(SignInModel *)model;
@property(nonatomic,strong)id<SignInCellDelegate>delegate;
@end

