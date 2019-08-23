//
//  NoteCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@protocol NoteCellDelegate <NSObject>
-(void)clickFinishBtn:(UIButton *)btn note:(NoteModel *) note;
@end


@interface NoteCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;//标题
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UIView *leftview;
@property (nonatomic,strong) NoteModel *note;
@property (nonatomic,strong) UILabel *typeLabel;//类型
-(void)initViewWith:(NoteModel*)model sectionType:(NSString *) sectionType;
@property(nonatomic,strong)id<NoteCellDelegate>delegate;
@end
