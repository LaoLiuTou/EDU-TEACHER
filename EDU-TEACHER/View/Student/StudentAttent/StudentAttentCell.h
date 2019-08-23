//
//  StudentAttentCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttentModel.h"

@interface StudentAttentCell : UITableViewCell
@property (nonatomic,strong) UILabel *levelLabel;//标题
@property (nonatomic,strong) UILabel *c_timeLabel;//发布时间
@property (nonatomic,strong) UILabel *timeLabel;//谈话地点
-(void)initViewWithModel:(StudentAttentModel *) model;

@end

