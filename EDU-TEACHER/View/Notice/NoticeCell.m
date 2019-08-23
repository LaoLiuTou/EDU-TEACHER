//
//  NoticeCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/10.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoticeCell.h"
#import "DEFINE.h"
@implementation NoticeCell

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
    
    [self.contentView addSubview:self.noticeImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusBtn];
    [self.contentView addSubview:self.publish_timeLabel];
    
    [self.contentView addSubview:self.readLabel];
    UIImageView *icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CenterAdd"]];
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(40);
        make.left.equalTo(self.contentView).offset((kWidth/2)+30);
        make.width.mas_equalTo(14.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
}
- (UIImageView *)noticeImage{
    if (!_noticeImage) {
        _noticeImage=[[UIImageView alloc]initWithFrame:CGRectMake(15.0, 10.0, 50, 50)];
        _noticeImage.image=[UIImage imageNamed:@"tongzhi_cell"];
    }
    return _noticeImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75.0, 10.0, (kWidth-160), 25.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    return _nameLabel;
}
- (UILabel *)publish_timeLabel{
    if (!_publish_timeLabel) {
        _publish_timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(75.0, 34.0, (kWidth-70)/2, 25.0)];
        [_publish_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
        _publish_timeLabel.textColor=[UIColor grayColor];
        _publish_timeLabel.text=@"0000-00-00 00:00";
    }
    return _publish_timeLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-85, 17.0, 70, 36)];
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_statusBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius=8;
        _statusBtn.layer.masksToBounds=YES;
        
        _statusBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
         [_statusBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _statusBtn;
}
- (UILabel *)readLabel{
    if (!_readLabel) {
        _readLabel=[[UILabel alloc]initWithFrame:CGRectMake((kWidth/2)+46, 34.0, (kWidth-70)/2, 25.0)];
        [_readLabel setFont:[UIFont systemFontOfSize:14.0]];
        _readLabel.textColor=[UIColor grayColor];
    }
    return _readLabel;
}


-(void)clickPublishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickPublishBtn:notice:)]){
        [self.delegate clickPublishBtn:sender notice:self.notice];
    }
    
}

 
@end
