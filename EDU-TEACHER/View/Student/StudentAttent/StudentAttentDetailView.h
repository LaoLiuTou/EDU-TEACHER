//
//  StudentAttentDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttentModel.h"

@interface StudentAttentDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UILabel *timeLabel;//谈话时间
@property (nonatomic,strong) UILabel *levelLabel;//谈话事由
@property (nonatomic,strong) UILabel *commentLabel;//内容
@property (nonatomic,strong) StudentAttentModel *studentAttentModel;//内容
-(int)initModel:(StudentAttentModel *)studentAttentModel;
@end

