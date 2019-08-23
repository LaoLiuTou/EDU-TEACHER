//
//  StudentTalkingDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentTalkingDetailView.h"
#import "DEFINE.h"
#import "UIImageView+WebCache.h"
#import "ImageZoomView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AttaVC.h"
 

@implementation StudentTalkingDetailView{
    int viewHeight;
}
 
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(TalkingModel *)talkingModel  type:(NSString *)type{
    self.talkingModel=talkingModel;
    [self initView:type];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView:(NSString *) type{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    if([type isEqualToString:@"0"]){
         leftview.backgroundColor=GKColorRGB(239, 43, 0);
    }
    else{
        leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    }
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =_talkingModel.xs_name;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    viewHeight=0;
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    
    
    //时间
    UILabel *timeTitleLabel=[[UILabel alloc] init];
    timeTitleLabel.backgroundColor=[UIColor whiteColor];
    timeTitleLabel.font=[UIFont systemFontOfSize:16];
    timeTitleLabel.text=@"谈话时间";
    timeTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *timeLabel=[[UILabel alloc] init];
    timeLabel.backgroundColor=[UIColor whiteColor];
    timeLabel.font=[UIFont systemFontOfSize:14];
    timeLabel.text=_talkingModel.talk_time;
    timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //通知人
    UILabel *adderTitleLabel=[[UILabel alloc] init];
    adderTitleLabel.backgroundColor=[UIColor whiteColor];
    adderTitleLabel.font=[UIFont systemFontOfSize:16];
    adderTitleLabel.text=@"创建时间";
    adderTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:adderTitleLabel];
    [adderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *adderLabel=[[UILabel alloc] init];
    adderLabel.backgroundColor=[UIColor whiteColor];
    adderLabel.font=[UIFont systemFontOfSize:14];
    adderLabel.text=_talkingModel.c_time;
    adderLabel.textColor=[UIColor grayColor];
    [commentback addSubview:adderLabel];
    [adderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50;
    
    UIFont *font=[UIFont systemFontOfSize:14];
    //地址
    UILabel *addressTitleLabel=[[UILabel alloc] init];
    addressTitleLabel.backgroundColor=[UIColor whiteColor];
    addressTitleLabel.font=[UIFont systemFontOfSize:16];
    addressTitleLabel.text=@"谈话地址";
    addressTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:addressTitleLabel];
    [addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(65);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *address=_talkingModel.address;
    CGFloat addressHeight = [address boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    UILabel *addressLabel=[[UILabel alloc] init];
    _addressLabel=addressLabel;
    _addressLabel.backgroundColor=[UIColor whiteColor];
    _addressLabel.font=[UIFont systemFontOfSize:14];
    _addressLabel.text =address;
    _addressLabel.textColor =[UIColor grayColor];
    [_addressLabel setTextAlignment:NSTextAlignmentLeft];
    [_addressLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_addressLabel setNumberOfLines:0];
    [_addressLabel sizeToFit];
    [commentback addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(addressHeight);
    }];
    viewHeight+=addressHeight+25+30;
    
    
    //原因
    UILabel *reasonTitleLabel=[[UILabel alloc] init];
    reasonTitleLabel.backgroundColor=[UIColor whiteColor];
    reasonTitleLabel.font=[UIFont systemFontOfSize:16];
    reasonTitleLabel.text=@"谈话事由";
    reasonTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:reasonTitleLabel];
    [reasonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *reason=_talkingModel.reason;
    CGFloat reasonHeight = [reason boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    UILabel *reasonLabel=[[UILabel alloc] init];
    _reasonLabel=reasonLabel;
    _reasonLabel.backgroundColor=[UIColor whiteColor];
    _reasonLabel.font=[UIFont systemFontOfSize:14];
    _reasonLabel.text =reason;
    _reasonLabel.textColor =[UIColor grayColor];
    [_reasonLabel setTextAlignment:NSTextAlignmentLeft];
    [_reasonLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_reasonLabel setNumberOfLines:0];
    [_reasonLabel sizeToFit];
    [commentback addSubview:_reasonLabel];
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(reasonHeight);
    }];
    viewHeight+=reasonHeight+25+20;
    
    
    //内容
    UILabel *commentTitleLabel=[[UILabel alloc] init];
    commentTitleLabel.backgroundColor=[UIColor whiteColor];
    commentTitleLabel.font=[UIFont systemFontOfSize:16];
    commentTitleLabel.text=@"谈话内容";
    commentTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitleLabel];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(15);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *comment=_talkingModel.comment;
    CGFloat commentHeight = [comment boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *commentLabel=[[UILabel alloc] init];
    _commentLabel=commentLabel;
    _commentLabel.backgroundColor=[UIColor whiteColor];
    _commentLabel.font=[UIFont systemFontOfSize:14];
    _commentLabel.text =comment;
    _commentLabel.textColor =[UIColor grayColor];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_commentLabel setNumberOfLines:0];
    [_commentLabel sizeToFit];
    [commentback addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(commentHeight);
    }];
    viewHeight+=commentHeight+25+20;
    
    
    //后续
    UILabel *followTitleLabel=[[UILabel alloc] init];
    followTitleLabel.backgroundColor=[UIColor whiteColor];
    followTitleLabel.font=[UIFont systemFontOfSize:16];
    followTitleLabel.text=@"后续关注措施";
    followTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:followTitleLabel];
    [followTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).offset(15);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *follow=_talkingModel.follow;
    CGFloat followHeight = [reason boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    UILabel *followLabel=[[UILabel alloc] init];
    _followLabel=followLabel;
    _followLabel.backgroundColor=[UIColor whiteColor];
    _followLabel.font=[UIFont systemFontOfSize:14];
    _followLabel.text =follow;
    _followLabel.textColor =[UIColor grayColor];
    [_followLabel setTextAlignment:NSTextAlignmentLeft];
    [_followLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_followLabel setNumberOfLines:0];
    [_followLabel sizeToFit];
    [commentback addSubview:_followLabel];
    [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(followTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(followHeight);
    }];
    viewHeight+=followHeight+25+20;
    
    
    if([_talkingModel.files count]>0){
        //附件
        UIImageView *fujianIcon=[[UIImageView alloc] init];
        _fujianIcon=fujianIcon;
        _fujianIcon.image=[UIImage imageNamed:@"fujian"];
        [commentback addSubview:_fujianIcon];
        [_fujianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.followLabel.mas_bottom).offset(30);
            make.left.equalTo(commentback).offset(15);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        UILabel *fujianTitleLabel=[[UILabel alloc] init];
        fujianTitleLabel.backgroundColor=[UIColor whiteColor];
        fujianTitleLabel.font=[UIFont systemFontOfSize:16];
        fujianTitleLabel.text=@"附件";
        fujianTitleLabel.textColor=[UIColor blackColor];
        [commentback addSubview:fujianTitleLabel];
        [fujianTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.followLabel.mas_bottom).offset(30);
            make.left.equalTo(commentback).offset(40);
            make.width.mas_equalTo((kWidth-30)/2);
            make.height.mas_equalTo(20);
        }];
        int height=[self initFujianView];
        self->viewHeight+=height;
    }
    viewHeight+=50;
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(self->viewHeight);
    }];
    viewHeight=50+3*6+viewHeight;
}

//图片
-(int) initFujianView{
    
    int height=0;
    UIView *fujianView=[[UIView alloc] init];
    [self addSubview:fujianView];
    NSInteger row = 4;
    NSInteger line = ceil(((float)[self.talkingModel.files count])/row);
    CGFloat margin = 8;
    CGFloat buttonW = (kWidth-30-(row-1)*margin)/row;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < [self.talkingModel.files count]; i++) {
        NSDictionary *fujianDic=[self.talkingModel.files objectAtIndex:i];
        NSString *fileTypeImage=@"";
        if([fujianDic objectForKey:@"type"]==[NSNull null]){
            fileTypeImage=@"wenjian";
        }
        else if([[fujianDic objectForKey:@"type"] isEqualToString:@"图片"]){
            fileTypeImage=@"image";
        }
        else if([[fujianDic objectForKey:@"type"] isEqualToString:@"视频/音频"]){
            fileTypeImage=@"shipin";
        }
        else{//文档
            fileTypeImage=@"wenjian";
        }
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(i%row*(buttonW+margin), i/row*(buttonH+margin), buttonW, buttonH);
        [button addTarget:self action:@selector(fujianClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button setBackgroundImage: [UIImage imageNamed:fileTypeImage] forState:UIControlStateNormal];
        NSString *attaName=[fujianDic objectForKey:@"name"]==[NSNull null]?[NSString stringWithFormat:@"%@%@",[fujianDic objectForKey:@"type"],@"附件"]:[fujianDic objectForKey:@"name"];
        [button setTitle:attaName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.bounds =CGRectMake(0, 0, 48, 48);
        //button.imageEdgeInsets=UIEdgeInsetsMake(10, 0, -10, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(64,-20,0,-20);
        button.tag = 100+i;
        [fujianView addSubview:button];
    }
    [fujianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fujianIcon.mas_bottom).offset(-10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(line*buttonW);
    }];
    height=(line+1)*8+buttonH*line;
    return height;
}

- (void)fujianClick:(UIButton *)btn {
    
    NSDictionary *attaDic=self.talkingModel.files[btn.tag-100];
    [self download:attaDic];
    
    
    
}

-(void)download:(NSDictionary *)attaDic{
    
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showProgress:0.0];
    
    NSString *fileUrl=[attaDic objectForKey:@"url"];
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    //2.创建下载任务
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     downloadProgress.completedUnitCount:已经完成的大小
     downloadProgress.totalUnitCount:文件的总大小
     第三个参数:destination 自动完成文件剪切操作
     返回值:该文件应该被剪切到哪里
     targetPath:临时路径 tmp NSURL
     response:响应头
     第四个参数:completionHandler 下载完成回调
     filePath:真实路径 == 第三个参数的返回值
     error:错误信息
     */
    NSURLSessionDownloadTask *downlaodTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showProgress:(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount)];
        //计算文件的下载进度
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //文件的全路径
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSURL *fileUrl = [NSURL fileURLWithPath:fullpath];
        
        NSLog(@"%@\n%@",targetPath,fullpath);
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        [SVProgressHUD dismiss];
        AttaVC *attaVC = [[AttaVC alloc]init];
        attaVC.url = filePath;
        [[self currentViewController].navigationController pushViewController: attaVC animated:NO];
        
    }];
    
    //3.执行Task
    [downlaodTask resume];
}

-(UIViewController *)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end

