//
//  LeaveListCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/3.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveListCell.h"
#import "DEFINE.h"
@implementation LeaveListCell
 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initView{
    [self.contentView addSubview:self.typeLabel];
    //姓名
    [self.contentView addSubview:self.xs_nameLabel]; 
    [self.contentView addSubview:self.start_timeLabel];
    [self.contentView addSubview:self.end_timeLabel];
    [self.contentView addSubview:self.statusLabel];
    
    
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
- (UILabel *)xs_nameLabel{
    if (!_xs_nameLabel) {
        _xs_nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.0, 12.0, (kWidth-70)/2, 25.0)];
        [_xs_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _xs_nameLabel;
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

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2,35.0, (kWidth-30)/2, 20.0)];
        [_statusLabel setFont:[UIFont systemFontOfSize:14.0]];
        _statusLabel.textAlignment=NSTextAlignmentRight;
        _statusLabel.textColor=[UIColor darkGrayColor];
        _statusLabel.text=@"已审核";
        [_statusLabel setHidden:YES];
    }
    return _statusLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
 
