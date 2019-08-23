//
//  StudentHelpCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentHelpModel.h"

@interface StudentHelpCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//
@property (nonatomic,strong) UILabel *timeLabel;//
@property (nonatomic,strong) UILabel *moneyLabel;//
@property (nonatomic,strong) UILabel *organizationLabel;//
-(void)initViewWithModel:(StudentHelpModel *) model;
@end

