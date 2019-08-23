//
//  ActivityDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ActivityDetailView.h"
#import "DEFINE.h"
#import "UIImageView+WebCache.h"
#import "ImageZoomView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AttaVC.h"
@implementation ActivityDetailView{
    int viewHeight;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(ActivityModel *)activityModel{
    self.activityModel=activityModel;
    [self initView];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView{
    NSString *content=_activityModel.comment;
    UIFont *font=[UIFont systemFontOfSize:14];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =_activityModel.name;
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self).offset(kNavBarHeight+6);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    viewHeight=0;
    //通知内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    
    
    //发布时间
    UILabel *publish_timeTitle=[[UILabel alloc] init];
    publish_timeTitle.backgroundColor=[UIColor whiteColor];
    publish_timeTitle.font=[UIFont systemFontOfSize:16];
    publish_timeTitle.text=@"发布时间";
    publish_timeTitle.textColor=[UIColor blackColor];
    [commentback addSubview:publish_timeTitle];
    [publish_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *publish_timeLabel=[[UILabel alloc] init];
    publish_timeLabel.backgroundColor=[UIColor whiteColor];
    publish_timeLabel.font=[UIFont systemFontOfSize:14];
    publish_timeLabel.text=_activityModel.publish_time;
    publish_timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:publish_timeLabel];
    [publish_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //报名截止时间
    UILabel *baoming_endtimeTitle=[[UILabel alloc] init];
    baoming_endtimeTitle.backgroundColor=[UIColor whiteColor];
    baoming_endtimeTitle.font=[UIFont systemFontOfSize:16];
    baoming_endtimeTitle.text=@"报名截止时间";
    baoming_endtimeTitle.textColor=[UIColor blackColor];
    [commentback addSubview:baoming_endtimeTitle];
    [baoming_endtimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *baoming_endtimeLabel=[[UILabel alloc] init];
    baoming_endtimeLabel.backgroundColor=[UIColor whiteColor];
    baoming_endtimeLabel.font=[UIFont systemFontOfSize:14];
    baoming_endtimeLabel.text=_activityModel.baoming_endtime;
    baoming_endtimeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:baoming_endtimeLabel];
    [baoming_endtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    
    //活动类型
    UILabel *typeTitle=[[UILabel alloc] init];
    typeTitle.backgroundColor=[UIColor whiteColor];
    typeTitle.font=[UIFont systemFontOfSize:16];
    typeTitle.text=@"活动类型";
    typeTitle.textColor=[UIColor blackColor];
    [commentback addSubview:typeTitle];
    [typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *typeLabel=[[UILabel alloc] init];
    typeLabel.backgroundColor=[UIColor whiteColor];
    typeLabel.font=[UIFont systemFontOfSize:14];
    typeLabel.text=_activityModel.type;
    typeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //限制人数
    UILabel *numberTitle=[[UILabel alloc] init];
    numberTitle.backgroundColor=[UIColor whiteColor];
    numberTitle.font=[UIFont systemFontOfSize:16];
    numberTitle.text=@"限制人数";
    numberTitle.textColor=[UIColor blackColor];
    [commentback addSubview:numberTitle];
    [numberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *numberLabel=[[UILabel alloc] init];
    numberLabel.backgroundColor=[UIColor whiteColor];
    numberLabel.font=[UIFont systemFontOfSize:14];
    if(_activityModel.number==nil||[_activityModel.number isEqualToString:@""]){
        numberLabel.text=@"不限人数";
    }
    else{
        numberLabel.text=_activityModel.number;
    }
    
    numberLabel.textColor=[UIColor grayColor];
    [commentback addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    
    //发布人
    UILabel *publish_nameTitle=[[UILabel alloc] init];
    publish_nameTitle.backgroundColor=[UIColor whiteColor];
    publish_nameTitle.font=[UIFont systemFontOfSize:16];
    publish_nameTitle.text=@"发布人";
    publish_nameTitle.textColor=[UIColor blackColor];
    [commentback addSubview:publish_nameTitle];
    [publish_nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60+50);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *publish_nameLabel=[[UILabel alloc] init];
    publish_nameLabel.backgroundColor=[UIColor whiteColor];
    publish_nameLabel.font=[UIFont systemFontOfSize:14];
    publish_nameLabel.text=_activityModel.publish_name;
    publish_nameLabel.textColor=[UIColor grayColor];
    [commentback addSubview:publish_nameLabel];
    [publish_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //活动地址
    UILabel *addressTitle=[[UILabel alloc] init];
    addressTitle.backgroundColor=[UIColor whiteColor];
    addressTitle.font=[UIFont systemFontOfSize:16];
    addressTitle.text=@"活动地址";
    addressTitle.textColor=[UIColor blackColor];
    [commentback addSubview:addressTitle];
    [addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60+50);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *addressLabel=[[UILabel alloc] init];
    addressLabel.backgroundColor=[UIColor whiteColor];
    addressLabel.font=[UIFont systemFontOfSize:14];
    addressLabel.text=_activityModel.address==nil?@"无":_activityModel.address;
    addressLabel.textColor=[UIColor grayColor];
    [commentback addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    
    
    //活动开始时间
    UILabel *start_timeTitle=[[UILabel alloc] init];
    start_timeTitle.backgroundColor=[UIColor whiteColor];
    start_timeTitle.font=[UIFont systemFontOfSize:16];
    start_timeTitle.text=@"活动开始时间";
    start_timeTitle.textColor=[UIColor blackColor];
    [commentback addSubview:start_timeTitle];
    [start_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60+50+50);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *start_timeLabel=[[UILabel alloc] init];
    start_timeLabel.backgroundColor=[UIColor whiteColor];
    start_timeLabel.font=[UIFont systemFontOfSize:14];
    start_timeLabel.text=_activityModel.start_time==nil?@"无":_activityModel.start_time;
    start_timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:start_timeLabel];
    [start_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50+50);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //活动结束时间
    UILabel *end_timeTitle=[[UILabel alloc] init];
    end_timeTitle.backgroundColor=[UIColor whiteColor];
    end_timeTitle.font=[UIFont systemFontOfSize:16];
    end_timeTitle.text=@"活动结束时间";
    end_timeTitle.textColor=[UIColor blackColor];
    [commentback addSubview:end_timeTitle];
    [end_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(60+50+50);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *end_timeLabel=[[UILabel alloc] init];
    end_timeLabel.backgroundColor=[UIColor whiteColor];
    end_timeLabel.font=[UIFont systemFontOfSize:14];
    end_timeLabel.text=_activityModel.end_time==nil?@"无":_activityModel.end_time;
    end_timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:end_timeLabel];
    [end_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50+50);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    if(content!=nil){
        UIView *topLine= [[UIView alloc] init];
        topLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
        [commentback addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentback).offset(35+50+50+50+25);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(6.0f);
        }];
    }
   
    
    viewHeight+=50+50+50+50;
    //内容
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *commentTitle=[[UILabel alloc] init];
    commentTitle.backgroundColor=[UIColor whiteColor];
    commentTitle.font=[UIFont systemFontOfSize:16];
    commentTitle.text=@"活动内容";
    commentTitle.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitle];
    [commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50+50+40);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(20);
    }];
    UILabel *commentLabel=[[UILabel alloc] init];
    _commentLabel=commentLabel;
    _commentLabel.backgroundColor=[UIColor whiteColor];
    _commentLabel.font=[UIFont systemFontOfSize:14];
    _commentLabel.text =content;
    _commentLabel.textColor =[UIColor grayColor];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_commentLabel setNumberOfLines:0];
    [_commentLabel sizeToFit];
    [commentback addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35+50+50+50+40+25);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(contentHeight);
    }];
    viewHeight+=contentHeight+50;
    //图片
    UIImageView *imageView= [UIImageView new];
    [commentback addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    UITapGestureRecognizer *selectImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectImage:)];
    [imageView addGestureRecognizer:selectImageTap];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        if(self.activityModel.image == nil){
            make.height.mas_equalTo(0);
        }
        else{
            make.height.mas_equalTo(200);
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.activityModel.image]];
            self->viewHeight+=210;
        }
    }];
    if([self.activityModel.files count]>0){
        //附件
        UIImageView *fujianIcon=[[UIImageView alloc] init];
        _fujianIcon=fujianIcon;
        _fujianIcon.image=[UIImage imageNamed:@"fujian"];
        [commentback addSubview:_fujianIcon];
        [_fujianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
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
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.left.equalTo(commentback).offset(40);
            make.width.mas_equalTo((kWidth-30)/2);
            make.height.mas_equalTo(20);
        }];
        int height=[self initFujianView];
        self->viewHeight+=height;
    }
    viewHeight+=20;
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(self->viewHeight);
    }];
    viewHeight=kNavBarHeight+50+3*6+viewHeight;
}

//图片
-(int) initFujianView{
    
    int height=0;
    UIView *fujianView=[[UIView alloc] init];
    [self addSubview:fujianView];
    NSInteger row = 4;
    NSInteger line = ceil(((float)[self.activityModel.files count])/row);
    CGFloat margin = 8;
    CGFloat buttonW = (kWidth-30-(row-1)*margin)/row;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < [self.activityModel.files count]; i++) {
        NSDictionary *fujianDic=[self.activityModel.files objectAtIndex:i];
        NSString *fileTypeImage=@"";
        if([[fujianDic objectForKey:@"type"] isEqualToString:@"图片"]){
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
        make.top.equalTo(self.fujianIcon.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(line*buttonW);
    }];
    height=(line+1)*8+buttonH*line;
    return height;
}

- (void)fujianClick:(UIButton *)btn {
    
    NSDictionary *attaDic=self.activityModel.files[btn.tag-100];
    [self download:attaDic];
    
    
    
}
#pragma mark - 图片点击
-(void)clickSelectImage:(UITapGestureRecognizer *)tap{
    
    UIImageView *zoomImageView = [[UIImageView alloc]init];
    [zoomImageView sd_setImageWithURL:[NSURL URLWithString:self.activityModel.image]];
    ImageZoomView *imageZoomView=[[ImageZoomView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andWithImage: zoomImageView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageZoomView];
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
