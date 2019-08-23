//
//  StudentPunishCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentPunishCell.h"
#import "DEFINE.h"
@implementation StudentPunishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(StudentPunishModel *) model{
    self.nameLabel.text=[NSString stringWithFormat:@"%@",model.name];
    self.commentLabel.text=[NSString stringWithFormat:@"描述：%@",model.comment];
    self.timeLabel.text=model.date;
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo((kWidth-130));
        make.height.mas_equalTo(25);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(38);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorRGB(233, 37, 0);
    [self.contentView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        _nameLabel.textColor=[UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        _timeLabel.textColor=[UIColor darkGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel=[[UILabel alloc]init];
        [_commentLabel setFont:[UIFont systemFontOfSize:12.0]];
        _commentLabel.textColor=[UIColor blackColor];
    }
    return _commentLabel;
}


@end

