//
//  StudentTalkingDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingModel.h"
@interface StudentTalkingDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *addressLabel;//谈话地点
@property (nonatomic,strong) UILabel *reasonLabel;//谈话事由
@property (nonatomic,strong) UILabel *commentLabel;//内容
@property (nonatomic,strong) UILabel *followLabel;//后续处理
@property (nonatomic,strong) UIImageView *fujianIcon;
@property (nonatomic,strong) TalkingModel *talkingModel;
-(int)initModel:(TalkingModel *)talkingModel type:(NSString *)type;
@end

