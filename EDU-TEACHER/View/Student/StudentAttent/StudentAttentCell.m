//
//  StudentAttentCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentAttentCell.h"
#import "DEFINE.h"
@implementation StudentAttentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(StudentAttentModel *) model{
    self.levelLabel.text=[NSString stringWithFormat:@"关注级别:%@",model.level];
    self.c_timeLabel.text=[NSString stringWithFormat:@"%@",model.c_time];
    self.timeLabel.text=[NSString stringWithFormat:@"关注时间:%@",model.time];
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.c_timeLabel];
    [self.contentView addSubview:self.timeLabel];
    
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(((kWidth-30)/7)*4);
        make.height.mas_equalTo(25);
    }];
    [self.c_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(((kWidth-30)/7)*3);
        make.height.mas_equalTo(25);
    }];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    [self.contentView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel=[[UILabel alloc]init];
        [_levelLabel setFont:[UIFont systemFontOfSize:14.0]];
        _levelLabel.textColor=[UIColor blackColor];
    }
    return _levelLabel;
}
- (UILabel *)c_timeLabel{
    if (!_c_timeLabel) {
        _c_timeLabel=[[UILabel alloc]init];
        [_c_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _c_timeLabel.textColor=[UIColor grayColor];
        _c_timeLabel.textAlignment=NSTextAlignmentRight;
    }
    return _c_timeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 38.0, kWidth-30, 25.0)];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _timeLabel.textColor=[UIColor grayColor];
    }
    return _timeLabel;
}



@end
