//
//  NoticeStuCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/12.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoticeStuCellDelegate <NSObject>
-(void)clickNoticeBtn:(UIButton *)btn stuDic:(NSDictionary *) stu;
@end

@interface NoticeStuCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImage;//通知标题
@property (nonatomic,strong) UILabel *nameLabel;//通知标题
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) NSDictionary *stuDic;

@property(nonatomic,strong)id<NoticeStuCellDelegate>delegate;
@end


