//
//  StudentPunishCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentPunishModel.h"
@interface StudentPunishCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *timeLabel;//
@property (nonatomic,strong) UILabel *commentLabel;// 内容
-(void)initViewWithModel:(StudentPunishModel *) model;
@end

