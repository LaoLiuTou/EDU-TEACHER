//
//  ClassCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectClassCell.h"
#import "DEFINE.h" 
@implementation SelectClassCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}
-(void)initViewWithModel:(ClassModel *) model{
    
    
    self.nameLabel.text=[NSString stringWithFormat:@"课程名称：%@",model.lesson_name ];
    NSString *tempString = [NSString stringWithFormat:@"教师：%@",model.teacher];
    NSMutableAttributedString *tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,3)];
    self.teacherLabel.attributedText=tempAS;
    tempString = [NSString stringWithFormat:@"教室：%@",model.room==nil?@"":model.room ];
    tempAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",tempString]];
    [tempAS addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,3)];
    self.roomLabel.attributedText=tempAS;
    
}
#pragma mark - initView
- (void)initView{
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.teacherLabel];
    [self.contentView addSubview:self.roomLabel];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(22);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(30);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(45);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(25);
    }];
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorRGB(239, 165, 0);
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
- (UILabel *)teacherLabel{
    if (!_teacherLabel) {
        _teacherLabel=[[UILabel alloc]init];
        [_teacherLabel setFont:[UIFont systemFontOfSize:12.0]];
        _teacherLabel.textColor=[UIColor darkGrayColor];
    }
    return _teacherLabel;
}

- (UILabel *)roomLabel{
    if (!_roomLabel) {
        _roomLabel=[[UILabel alloc]init];
        [_roomLabel setFont:[UIFont systemFontOfSize:12.0]];
        _roomLabel.textColor=[UIColor darkGrayColor];
    }
    return _roomLabel;
}



@end
