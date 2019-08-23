//
//  LabelStuCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelStuCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImage;//通知标题
@property (nonatomic,strong) UILabel *nameLabel;//通知标题
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) NSDictionary *stuDic;
@end

NS_ASSUME_NONNULL_END
