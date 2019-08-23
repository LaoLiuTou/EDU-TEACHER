//
//  StudentHonorCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentHonorModel.h"

@interface StudentHonorCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *dateLabel;// 时间
@property (nonatomic,strong) UILabel *organizationLabel;//机构
-(void)initViewWithModel:(StudentHonorModel *) model;
@end

