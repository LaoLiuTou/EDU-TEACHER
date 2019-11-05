//
//  NoteDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoteDetailView.h"
#import "DEFINE.h"
#import "SVProgressHUD.h"
#import "AttaVC.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@implementation NoteDetailView{
    int viewHeight;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(NoteModel *)noteModel type:(NSString *) noteType{
    self.noteModel=noteModel;
    [self initView:noteType];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView:(NSString *) noteType{
    NSArray *colorArray=@[GKColorRGB(108, 180, 24),GKColorRGB(0, 200, 199),GKColorRGB(242, 164, 0),GKColorRGB(234, 37, 0)];
    
    NSString *content=_noteModel.comment;
    UIFont *font=[UIFont systemFontOfSize:14];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    //标题
    /*
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    if([noteType isEqualToString:@"工作日志"]){
        
        UILabel *nameLabel=[[UILabel alloc] init];
        _nameLabel=nameLabel;
        _nameLabel.backgroundColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont systemFontOfSize:16];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.text =_noteModel.name;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(kNavBarHeight+6);
            make.width.mas_equalTo(kWidth-45);
            make.height.mas_equalTo(50.0f);
        }];
    }
    else{
        UIView *leftview=[[UIView alloc] init];
        //leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
        leftview.backgroundColor=colorArray[[_noteModel.level integerValue] ];
        UILabel *nameLabel=[[UILabel alloc] init];
        _nameLabel=nameLabel;
        _nameLabel.backgroundColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont systemFontOfSize:16];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.text =_noteModel.name;
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
            make.width.mas_equalTo(kWidth-145);
            make.height.mas_equalTo(50.0f);
        }];
        
        UILabel *levelLabel=[[UILabel alloc] init];
        [self addSubview:levelLabel];
        levelLabel.backgroundColor=[UIColor whiteColor];
        levelLabel.font=[UIFont systemFontOfSize:16];
        levelLabel.textColor=[UIColor darkGrayColor];
        levelLabel.textAlignment=NSTextAlignmentRight;
        NSArray *titleArray=@[@"不重要不紧急",@"紧急不重要",@"重要不紧急",@"重要紧急"];
        levelLabel.text =titleArray[[_noteModel.level integerValue]];
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(kNavBarHeight+6);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(50.0f);
        }];
    }
    */
    
    viewHeight=0;
    //通知内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    
    
    //创建时间
    UILabel *timeTitleLabel=[[UILabel alloc] init];
    timeTitleLabel.backgroundColor=[UIColor whiteColor];
    timeTitleLabel.font=[UIFont systemFontOfSize:16];
    timeTitleLabel.text=@"创建时间";
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
    timeLabel.text=_noteModel.c_time;
    timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //提醒时间
    UILabel *adderTitleLabel=[[UILabel alloc] init];
    adderTitleLabel.backgroundColor=[UIColor whiteColor];
    adderTitleLabel.font=[UIFont systemFontOfSize:16];
    
    
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
    
    if([noteType isEqualToString:@"工作日志"]){
        
        if([self.noteModel.is_beiwang isEqualToString:@"true"]){
            adderTitleLabel.text=@"完成时间";
            adderLabel.text=_noteModel.end_time;
        }
        else{
            [adderTitleLabel setHidden:YES];
            [adderLabel  setHidden:YES];
        }
        
    }
    else{
        adderTitleLabel.text=@"提醒时间";
        adderLabel.text=_noteModel.remind_time;
    }
    
    adderLabel.textColor=[UIColor grayColor];
    [commentback addSubview:adderLabel];
    [adderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50;
    
    
    
    //内容
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *commentTitleLabel=[[UILabel alloc] init];
    commentTitleLabel.backgroundColor=[UIColor whiteColor];
    commentTitleLabel.font=[UIFont systemFontOfSize:16];
    commentTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitleLabel];
    if([noteType isEqualToString:@"工作日志"]){
        commentTitleLabel.text=@"日志内容";
        [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentback).offset(65);
            make.left.equalTo(commentback).offset(15);
            make.width.mas_equalTo(kWidth-30);
            make.height.mas_equalTo(20);
        }];
    }
    else{
        commentTitleLabel.text=@"备忘内容";
        [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentback).offset(65);
            make.left.equalTo(commentback).offset(25);
            make.width.mas_equalTo(kWidth-145);
            make.height.mas_equalTo(20);
        }];
        
        UIView *leftview=[[UIView alloc] init];
        //leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
        leftview.backgroundColor=colorArray[[_noteModel.level integerValue] ];
        [commentback addSubview:leftview];
        [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentback).offset(15);
            make.top.equalTo(commentback).offset(65);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(18);
        }];
        [self addSubview:_nameLabel];
        
        
        UILabel *levelLabel=[[UILabel alloc] init];
        [commentback addSubview:levelLabel];
        levelLabel.backgroundColor=[UIColor whiteColor];
        levelLabel.font=[UIFont systemFontOfSize:16];
        levelLabel.textColor=[UIColor darkGrayColor];
        levelLabel.textAlignment=NSTextAlignmentRight;
        NSArray *titleArray=@[@"不重要不紧急",@"紧急不重要",@"重要不紧急",@"重要紧急"];
        levelLabel.text =titleArray[[_noteModel.level integerValue]];
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(commentback).offset(-15);
             make.top.equalTo(commentback).offset(65);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20.0f);
        }];
    }
    
    
    
    
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
        make.top.equalTo(commentback).offset(90);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(contentHeight);
    }];
    viewHeight+=contentHeight+55;
    
    
    if([noteType isEqualToString:@"工作日志"]){
         
        
        if([self.noteModel.file_list count]>0){
            //附件
            UIImageView *fujianIcon=[[UIImageView alloc] init];
            _fujianIcon=fujianIcon;
            _fujianIcon.image=[UIImage imageNamed:@"fujian"];
            [commentback addSubview:_fujianIcon];
            [_fujianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.commentLabel.mas_bottom).offset(10);
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
                make.top.equalTo(self.commentLabel.mas_bottom).offset(10);
                make.left.equalTo(commentback).offset(40);
                make.width.mas_equalTo((kWidth-30)/2);
                make.height.mas_equalTo(20);
            }];
            int height=[self initFujianView];
            self->viewHeight+=height;
        }
        
    }
    
    
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kNavBarHeight+6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(self->viewHeight);
    }];
    viewHeight=kNavBarHeight+2*6+viewHeight;
}
//图片
-(int) initFujianView{
    
    int height=0;
    UIView *fujianView=[[UIView alloc] init];
    [self addSubview:fujianView];
    NSInteger row = 4;
    NSInteger line = ceil(((float)[self.noteModel.file_list count])/row);
    CGFloat margin = 8;
    CGFloat buttonW = (kWidth-30-(row-1)*margin)/row;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < [self.noteModel.file_list count]; i++) {
        NSDictionary *fujianDic=[self.noteModel.file_list objectAtIndex:i];
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
    
    NSDictionary *attaDic=self.noteModel.file_list[btn.tag-100];
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

