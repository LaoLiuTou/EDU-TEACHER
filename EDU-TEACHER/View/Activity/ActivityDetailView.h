//
//  ActivityDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *commentLabel;//内容
@property (nonatomic,strong) UIImageView *fujianIcon;
@property (nonatomic,strong) ActivityModel *activityModel;
-(int)initModel:(ActivityModel *)activityModel;
@end

NS_ASSUME_NONNULL_END
