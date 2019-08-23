//
//  LeaveDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/4.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveDetailView.h"
#import "DEFINE.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ImageZoomView.h"
@implementation LeaveDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
         
    }
    return self;
}
#pragma mark - initView
- (void)initView{
    [self addSubview:self.typeLabel];
    [self addSubview:self.xs_nameLabel];
    [self addSubview:self.statusLabel];
 
    
    UILabel *headerTopLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 6)];
    headerTopLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:headerTopLine];
    
    UILabel *headerBottomLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, kWidth, 6)];
    headerBottomLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:headerBottomLine];
   
    for(int i=0;i<[_titleArray count];i++){
    
        
        UILabel *titleLabel=[[UILabel alloc] init];
        UILabel *valueLabel=[[UILabel alloc] init];
        if(i%2==0){
            titleLabel.frame=CGRectMake(15, 70+(i*25), (kWidth-30)/2, 20.0);
            valueLabel.frame=CGRectMake(15, 90+(i*25), (kWidth-30)/2, 20.0);
        }
        else{
            titleLabel.frame=CGRectMake(kWidth/2, 70+((i-1)*25), (kWidth-30)/2, 20.0);
            valueLabel.frame=CGRectMake(kWidth/2,90+((i-1)*25), (kWidth-30)/2, 20.0);
        }
        [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.text=[_titleArray objectAtIndex:i];
        [self addSubview:titleLabel];
        [valueLabel  setFont:[UIFont systemFontOfSize:12.0]];
        valueLabel.textColor=[UIColor grayColor];
        if([[_titleArray objectAtIndex:i] isEqualToString:@"是否销假"]){
            valueLabel.tag=1005;
        }
        else  if([[_titleArray objectAtIndex:i] isEqualToString:@"审批人"]){
            valueLabel.tag=1006;
        }
        else if([[_titleArray objectAtIndex:i] isEqualToString:@"审批时间"]){
            valueLabel.tag=1007;
        }
        else if([[_titleArray objectAtIndex:i] isEqualToString:@"销假时间"]){
            valueLabel.tag=1008;
        }
        else{
            valueLabel.tag=1000+i;
        }
        
        [self addSubview:valueLabel];
        
        //valueLabel.text=[NSString stringWithFormat:@"%@%ld",[_titleArray objectAtIndex:i],(long)valueLabel.tag];
    }
    
    UILabel *contentBottomLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 70+ 50*ceil(((float)[_titleArray count])/2), kWidth, 6)];
    _contentBottomLine=contentBottomLine;
    _contentBottomLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:_contentBottomLine];
    
//    [self initReasonView];
//    [self initAlbumView];
//    [self initLessonAndProveView];
//    [self initRejectView];
    
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
        _xs_nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.0, 13.0, (kWidth-70)/2, 25.0)];
        [_xs_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _xs_nameLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2, 13.0, (kWidth/2)-15, 25.0)];
        [_statusLabel setFont:[UIFont systemFontOfSize:14.0]];
        _statusLabel.textAlignment=NSTextAlignmentRight;
    }
    return _statusLabel;
}
//请假原因
-(void) initReasonView{
    UILabel *reasonTitleLabel=[[UILabel alloc]init];
    reasonTitleLabel.text=@"请假原因";
    [reasonTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:reasonTitleLabel];
    [reasonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBottomLine).offset(20);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    UILabel *reasonLabel=[[UILabel alloc]init];
    _reasonLabel=reasonLabel;
    [_reasonLabel setFont:[UIFont systemFontOfSize:12.0]];
    _reasonLabel.textColor=[UIColor grayColor];
    [_reasonLabel setTextAlignment:NSTextAlignmentLeft];
    [_reasonLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_reasonLabel setNumberOfLines:0];
    //[_reasonLabel sizeToFit];
    [self addSubview:_reasonLabel];
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBottomLine).offset(45);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
         make.height.mas_equalTo(15); 
    }];
    
}


//图片
-(void) initAlbumView{
    
    UIView *albumView=[[UIView alloc] init];
    _albumView=albumView;
    [self addSubview:_albumView];
    
    NSInteger row = 4; // 三列
    NSInteger line = ceil(((float)[_imageArray count])/row);
    CGFloat margin = 8;
    CGFloat buttonW = (kWidth-30-(row-1)*margin)/row;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < [_imageArray count]; i++) {
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(i%row*(buttonW+margin), i/row*(buttonH+margin), buttonW, buttonH);
        //button.backgroundColor = [UIColor redColor];
       
        [button sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
         button.imageView.clipsToBounds = YES; // 裁剪边缘
        [button addTarget:self action:@selector(albumItemClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [_albumView addSubview:button];
        
    }
    [_albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(line*buttonW);
    }];
    
}

//课程 证明人
-(void) initLessonAndProveView{
   
    
    UILabel *lessonTitleLabel=[[UILabel alloc] init];
    [lessonTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    lessonTitleLabel.text=@"请假期间课程";
    lessonTitleLabel.textColor=[UIColor blackColor];
    [self addSubview:lessonTitleLabel];
    [lessonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *lessonLabel=[[UILabel alloc] init];
    _lessonLabel=lessonLabel;
    [_lessonLabel  setFont:[UIFont systemFontOfSize:12.0]];
    _lessonLabel.textColor=[UIColor grayColor];
    [self addSubview:_lessonLabel];
    [_lessonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lessonTitleLabel.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *proveTitleLabel=[[UILabel alloc] init];
    [proveTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    proveTitleLabel.text=@"证明人";
    proveTitleLabel.textColor=[UIColor blackColor];
    [self addSubview:proveTitleLabel];
    [proveTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumView.mas_bottom).offset(15);
        make.left.mas_equalTo(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *proveLabel=[[UILabel alloc] init];
    _zm_nameLabel=proveLabel;
    [_zm_nameLabel  setFont:[UIFont systemFontOfSize:12.0]];
    _zm_nameLabel.textColor=[UIColor grayColor];
    [self addSubview:_zm_nameLabel];
    [_zm_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proveTitleLabel.mas_bottom);
        make.left.mas_equalTo(kWidth/2);
        //make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *proveStatusLabel=[[UILabel alloc] init];
    _zm_statusLabel=proveStatusLabel;
    [_zm_statusLabel  setFont:[UIFont systemFontOfSize:12.0]];
    _zm_statusLabel.layer.cornerRadius=4;
    _zm_statusLabel.layer.masksToBounds=YES;
    _zm_statusLabel.textColor=[UIColor grayColor];
    [self addSubview:_zm_statusLabel];
    [_zm_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proveTitleLabel.mas_bottom);
        make.left.equalTo(self.zm_nameLabel.mas_right).offset(10);
        //make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
   
}
//拒绝原因
-(void) initRejectView{
    UILabel *topLine=[[UILabel alloc] init];
    topLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zm_nameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6);
    }];
    
    UILabel *rejectTitleLabel=[[UILabel alloc] init];
    [rejectTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    rejectTitleLabel.text=@"拒绝原因";
    rejectTitleLabel.textColor=[UIColor blackColor];
    [self addSubview:rejectTitleLabel];
    [rejectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *reasonLabel=[[UILabel alloc]init];
    _rejectLabel=reasonLabel;
    [_rejectLabel setFont:[UIFont systemFontOfSize:12.0]];
    _rejectLabel.textColor=[UIColor grayColor];
    [_rejectLabel setTextAlignment:NSTextAlignmentLeft];
    [_rejectLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_rejectLabel setNumberOfLines:0];
    //[_reasonLabel sizeToFit];
    [self addSubview:_rejectLabel];
    [_rejectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rejectTitleLabel.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
        //make.bottom.equalTo(self);
    }];
    
    
}


-(void)albumItemClick:(UIButton *)sender{
    UIImageView *zoomImageView = [[UIImageView alloc]init];
    [zoomImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:(sender.tag-100)]]];
    ImageZoomView *imageZoomView=[[ImageZoomView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andWithImage: zoomImageView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageZoomView];
}

@end
