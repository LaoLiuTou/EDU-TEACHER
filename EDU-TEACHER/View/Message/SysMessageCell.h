//
//  SysMessageCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/17.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysMessageModel.h"

@interface SysMessageCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel; 

@property (nonatomic,strong) SysMessageModel *messageModel;
-(void)initViewWithModel:(SysMessageModel *) model;
@end
