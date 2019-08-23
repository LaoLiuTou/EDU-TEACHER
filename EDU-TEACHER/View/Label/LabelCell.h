//
//  LabelCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LabelModel.h"
@protocol LabelCellDelegate <NSObject>
-(void)clickDelBtn:(UIButton *)btn model:(LabelModel *) model ;
@end

@interface LabelCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLabel;//
@property (nonatomic,strong) UILabel *remarkLabel;//
@property (nonatomic,strong) UILabel *timeLabel;//
@property (nonatomic,strong) UIButton *delBtn;//
@property (nonatomic,strong) LabelModel *labelModel;
-(void)initViewWithModel:(LabelModel *) model;
@property(nonatomic,strong)id<LabelCellDelegate>delegate;
@end
