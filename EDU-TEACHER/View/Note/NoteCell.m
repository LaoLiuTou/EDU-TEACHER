//
//  NoteCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoteCell.h"
#import "DEFINE.h"
@implementation NoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        //[self initView];
    }
    return self;
}

#pragma mark - initView
-(void)initViewWith:(NoteModel*)model sectionType:(NSString *) sectionType{
    NSArray *colorArray=@[GKColorRGB(108, 180, 24),GKColorRGB(0, 200, 199),GKColorRGB(242, 164, 0),GKColorRGB(234, 37, 0)];
    
    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.statusBtn];
     
    UIView *leftview=[[UIView alloc] init];
    _leftview=leftview;
    [self.contentView addSubview:_leftview];
    [_leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(kWidth-30-80);
        make.height.mas_equalTo(20);
    }];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
    //self.nameLabel.text=model.name;
    self.nameLabel.text=model.comment.length>10?[NSString stringWithFormat:@"%@...",[model.comment substringToIndex:10]]:model.comment;
    if([sectionType isEqualToString:@"工作备忘"]){
        _leftview.backgroundColor=colorArray[[model.level integerValue] ];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25);
            make.top.equalTo(self.contentView).offset(12);
            make.width.mas_equalTo(kWidth-30-80);
            make.height.mas_equalTo(20);
        }];
        self.timeLabel.text=[NSString stringWithFormat:@"提醒时间：%@",model.c_time];
    }
    else{
        
        if([model.is_beiwang isEqualToString:@"true"]){
            self.timeLabel.text=[NSString stringWithFormat:@"完成时间：%@",model.c_time];
            [self.contentView addSubview:self.typeLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(60);
                make.top.equalTo(self.contentView).offset(12);
                make.width.mas_equalTo(kWidth-30-80);
                make.height.mas_equalTo(20);
            }];
        }
        else{
            self.timeLabel.text=[NSString stringWithFormat:@"创建时间：%@",model.c_time];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView).offset(12);
                make.width.mas_equalTo(kWidth-30-80);
                make.height.mas_equalTo(20);
            }];
        }
        
    }
    
    
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:13.0]];
        _timeLabel.textColor=[UIColor grayColor];
        _timeLabel.text=@"0000-00-00 00:00";
    }
    return _timeLabel;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15.0, 12.0, 40, 20.0)];
        [_typeLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_typeLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _typeLabel.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _typeLabel.layer.mask = cornerRadiusLayer;
        _typeLabel.textColor=[UIColor whiteColor];
        _typeLabel.textAlignment=NSTextAlignmentCenter;
        _typeLabel.text=@"备忘"; 
        [_typeLabel setBackgroundColor:GKColorHEX(0x2c92f5, 1)];
        
        
    }
    return _typeLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]init];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_statusBtn addTarget:self action:@selector(clickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=8;
        _statusBtn.layer.masksToBounds=YES;
        
        _statusBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_statusBtn setTitle:@"完结" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _statusBtn;
}
 

-(void)clickFinishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickFinishBtn:note:)]){
        [self.delegate clickFinishBtn:sender note:self.note];
    }
    
}


@end

