//
//  NoticeDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/12.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *commentLabel;//内容
@property (nonatomic,strong) UIImageView *fujianIcon;
@property (nonatomic,strong) NoticeModel *noticeModel;
-(int)initModel:(NoticeModel *)noticeModel;
@end

NS_ASSUME_NONNULL_END
