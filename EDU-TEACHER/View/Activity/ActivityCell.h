//
//  ActivityCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityModel.h"
@protocol ActivityCellDelegate <NSObject>
-(void)clickPublishBtn:(UIButton *)btn activity:(ActivityModel *) activityModel;
@end


@interface ActivityCell : UITableViewCell

@property (nonatomic,strong) UIImageView *activityImage;//图片
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) UILabel *publish_timeLabel;//发布时间
@property (nonatomic,strong) UILabel *publish_nameLabel;//发布人
@property (nonatomic,strong) UILabel *baoming_endtimeLabel;//发布人
@property (nonatomic,strong) ActivityModel *activityModel;//通知
- (void)initViewWith:(ActivityModel *) activityModel;
@property(nonatomic,strong)id<ActivityCellDelegate>delegate;

@end
