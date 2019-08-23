//
//  DevicesCell.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/29.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "DevicesCell.h"
#import "DEFINE.h"
@implementation DevicesCell


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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusImage];
    [self.contentView addSubview:self.iconImage];
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 0, kWidth-100, 40.0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        _nameLabel.textColor=[UIColor blackColor];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        
    }
    return _nameLabel;
}
- (UIImageView *)statusImage{
    if (!_statusImage) {
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 24, 24)];
        _statusImage=iconImageView;
        
        if([_status isEqualToString:@"select"]){
            _statusImage.image = [UIImage imageNamed:@"xuanzhong"];
        }
        else{
            _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
        }
        
    }
    return _statusImage;
}
- (UIImageView *)iconImage{
    if (!_iconImage) {
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 24, 24)];
        _iconImage=iconImageView;
        _iconImage.image = [UIImage imageNamed:@"lanya"];
    }
    return _iconImage;
}
-(void)chageStatus:(NSString *)status{
    
    if([status isEqualToString:@"select"]){
        _statusImage.image = [UIImage imageNamed:@"xuanzhong"];
    }
    else{
        _statusImage.image = [UIImage imageNamed:@"weixuanzhong"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
