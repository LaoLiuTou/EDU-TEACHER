//
//  ScanRegisterCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/10/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanRegisterModel.h"
@protocol ScanRegisterCellDelegate <NSObject>
-(void)clickStateBtn:(UIButton *)btn model:(ScanRegisterModel *) scanModel state:(NSString *) state;
@end


@interface ScanRegisterCell : UITableViewCell


@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UIImageView *labelImage;//性别图标
@property (nonatomic,strong) UIButton *agreenBtn;//状态
@property (nonatomic,strong) UIButton *rejectBtn;//状态
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) UILabel *timeLabel;//发布时间 
-(void)initViewWith:(ScanRegisterModel*)model;
@property (nonatomic,strong) ScanRegisterModel *scanModel;//通知
@property(nonatomic,strong)id<ScanRegisterCellDelegate>delegate;
@end
