//
//  SignInListCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SignInListCell.h"
#import "DEFINE.h"
@implementation SignInListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        //[self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initView:(SignInModel *)model{
    [self.contentView addSubview:self.typeLabel];
    //姓名
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.start_timeLabel];
    [self.contentView addSubview:self.end_timeLabel];
    [self.contentView addSubview:self.statusButton];
    [self.contentView addSubview:self.statusLabel];
    [self.statusButton setHidden:YES];
    [self.statusLabel setHidden:YES];
    [self.statusButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        //make.width.mas_equalTo(70);
        make.height.mas_equalTo(36);
    }];

    [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(36);
    }];
    
}
 
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15.0, 15.0, 40, 20.0)];
        [_typeLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_typeLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _typeLabel.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _typeLabel.layer.mask = cornerRadiusLayer;
        _typeLabel.textColor=[UIColor whiteColor];
        _typeLabel.textAlignment=NSTextAlignmentCenter;
        
        
        
    }
    return _typeLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.0, 12.0, (kWidth-70)/2, 25.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _nameLabel;
}

- (UILabel *)start_timeLabel{
    if (!_start_timeLabel) {
        _start_timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,40.0, kWidth-30, 20.0)];
        [_start_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _start_timeLabel.textAlignment=NSTextAlignmentLeft;
        _start_timeLabel.textColor=[UIColor darkGrayColor];
        _start_timeLabel.text=@"提交时间:";
    }
    return _start_timeLabel;
}
- (UILabel *)end_timeLabel{
    if (!_end_timeLabel) {
        _end_timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,60.0, kWidth-30, 20.0)];
        [_end_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
        _end_timeLabel.textAlignment=NSTextAlignmentLeft;
        _end_timeLabel.textColor=[UIColor darkGrayColor];
        _end_timeLabel.text=@"提交时间:";
    }
    return _end_timeLabel;
}

- (UIButton *)statusButton{
    if (!_statusButton) {
       
        _statusButton=[[UIButton alloc]init];
        _statusButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_statusButton addTarget:self action:@selector(clickStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusButton.layer.cornerRadius=8;
        _statusButton.layer.masksToBounds=YES;
        _statusButton.backgroundColor=GKColorHEX(0x2c92f5,1);
    }
    return _statusButton;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc]init];
        _statusLabel.font=[UIFont systemFontOfSize:14];
        _statusLabel.textAlignment=NSTextAlignmentRight;
        _statusLabel.backgroundColor=[UIColor whiteColor];
        _statusLabel.textColor=[UIColor grayColor];
    }
    return _statusLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)clickStatusBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickStatusBtn:signin:)]){
        [self.delegate clickStatusBtn:sender signin:self.signin];
    }
    
}
@end


