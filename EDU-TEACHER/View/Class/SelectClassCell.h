//
//  ClassCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@interface SelectClassCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//
@property (nonatomic,strong) UILabel *teacherLabel;//
@property (nonatomic,strong) UILabel *roomLabel;//
-(void)initViewWithModel:(ClassModel *) model;
@end
