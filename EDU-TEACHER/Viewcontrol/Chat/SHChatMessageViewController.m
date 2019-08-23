//
//  SHChatMessageViewController.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHChatMessageViewController.h"
#import "SHMessageInputView.h"
#import "SHVoiceTableViewCell.h"
#import "DEFINE.h"
#import "ImageZoomView.h"
#import "SHChatMessageLocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "DataBaseHelper.h"
#import "ConverseTool.h"
#import "AFNetworking.h"
#import "LTAlertView.h"
@interface SHChatMessageViewController ()<
            SHMessageInputViewDelegate,//输入框代理
            SHChatMessageCellDelegate,//Cell代理
            SHAudioPlayerHelperDelegate,//语音播放代理
            UITableViewDelegate,
            UITableViewDataSource
            >
{
    //复制按钮
    UIMenuItem * _copyMenuItem;
    //删除按钮
    UIMenuItem * _deleteMenuItem;
    
}

//聊天界面
@property (nonatomic,strong) UITableView *chatTableView;
//下方工具栏
@property (nonatomic,strong) SHMessageInputView *chatInputView;
//背景图
@property (nonatomic, strong) UIImageView *bgImageView;
//未读
@property (nonatomic, strong) UIButton *unreadBtn;
//加载控件
@property (nonatomic, strong) UIRefreshControl *refresh;

//当前点击的Cell
@property (nonatomic, weak) SHMessageTableViewCell *selectCell;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

//显示的时间集合
@property (nonatomic, strong) NSMutableArray *timeArr;

@end

@implementation SHChatMessageViewController{
    int page;
    int pagesize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];
    
    //初始化各个参数
    self.view.backgroundColor = kInPutViewColor;
    self.dataSource = [[NSMutableArray alloc]init];
    //配置参数
    [self config];
    //注册通知：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshChatView:) name:@"RefreshChatView" object:nil];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=self.model.FRIEND_NAME;
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 配置参数
- (void)config{
    page=1;
    pagesize=10;
    //添加下方输入框
    [self.view addSubview:self.chatInputView];
    //添加聊天
    [self.view addSubview:self.chatTableView];
 
    //添加背景图
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    //添加加载
    if (@available(iOS 10.0, *)) {
        self.chatTableView.refreshControl = self.refresh;
    } else {
        // Fallback on earlier versions
    }
    //添加键盘监听
    [self addKeyboardNote];
    
    //配置未读控件
    //self.unreadBtn.tag = 20;
    //[self configUnread:20];
    
    //自动刷新
    [self autoRefresh];
    
}
-(void)autoRefresh{
    page=1;
    //加载数据
    if (self.refresh.refreshing) {
        //TODO: 已经在刷新数据了
    } else {
        if (self.chatTableView.contentOffset.y == 0) {
            
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void){
                                 self.chatTableView.contentOffset = CGPointMake(0, -self.refresh.frame.size.height);
                             } completion:^(BOOL finished){
                                 [self.refresh beginRefreshing];
                                 [self.refresh sendActionsForControlEvents:UIControlEventValueChanged];
                             }];
        }
    }
}

- (void)refreshChatView:(NSNotification *)notification{ 
    page=1;
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadChatData];
    
}
#pragma mark - 本地聊天数据
- (void)loadChatData{
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.dataSource.count) {
            //获取数据
            NSArray *temp = [self loadMeaaageDataisLoad:YES];
            if (temp.count) {
                //插入数据
                NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temp.count)];
                [self.dataSource insertObjects:temp atIndexes:indexes];
                
                [self.chatTableView reloadData];
                //滚动到刷新位置
                [self tableViewScrollToIndex:temp.count];
            }
            //配置未读控件
            //[self configUnread:(self.unreadBtn.tag - temp.count)];
        }else{
            //获取数据
            NSArray *temp = [self loadMeaaageDataisLoad:NO];
            if (temp.count) {
                //添加数据
                [self.dataSource addObjectsFromArray:temp];
                [self.chatTableView reloadData];
                //滚动到最下方
                [self tableViewScrollToBottom];
            }
            //配置未读控件
            //[self configUnread:(self.unreadBtn.tag - temp.count)];
        }
        [self.refresh endRefreshing];
        self->page++;
    //});
}

#pragma mark - 加载数据
- (NSArray <SHMessageFrame *>*)loadMeaaageDataisLoad:(BOOL)isLoad{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
    NSMutableArray *listDataArray =[dbh selectDataBase:chatDatabaseName tableName:@"CHAT_TABLE" columns:nil conditionColumns:@[@"FRIEND_ID"] values:@[self.model.FRIEND_ID] orderBy:@"ID" offset:(page-1)*pagesize limit:pagesize];
    
    //保存未读的messageId
    NSMutableArray *messageIds=[[NSMutableArray alloc]init];
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    NSMutableArray *loadTimeArr = [[NSMutableArray alloc]init];
   for (NSDictionary *tempChatDic in [listDataArray reverseObjectEnumerator]) {
        SHMessage *message=[[SHMessage alloc]init];
        message.messageId = [tempChatDic objectForKey:@"MI"]==[NSNull null]?@"":[tempChatDic objectForKey:@"MI"];
       
        if([[tempChatDic objectForKey:@"READ_STATUS"] isEqualToString:@"1"]){
            message.isRead = NO;
            [messageIds addObject:[tempChatDic objectForKey:@"MI"]];
        }
        else{
            message.isRead = YES;
        }
        message.messageRead = YES;
        message.messageState = SHSendMessageType_Successed;
        if([[tempChatDic objectForKey:@"CHAT_TYPE"] isEqualToString:@"1"]){
            message.bubbleMessageType = 1;
            message.avator=self.model.FRIEND_IMAGE;
        }
        else{
            message.bubbleMessageType = 0;
            message.avator=[jbad.userInfoDic objectForKey:@"IMG"] ;
        }
        message.sendTime = [tempChatDic objectForKey:@"ADD_TIME"];
        message.userId = [tempChatDic objectForKey:@"FRIEND_ID"];
        message.userName = [tempChatDic objectForKey:@"TITLE"];
        
        
        
        switch ([[tempChatDic objectForKey:@"CONTENT_TYPE"] integerValue]) {
            case 0:
                //message = [SHMessageHelper addPublicParameters];
                message.messageType = SHMessageBodyType_text;
                message.text = [ConverseTool formBase64Str:[tempChatDic objectForKey:@"CONTEXT"]];
                break;
            case 1:
                message.messageType = SHMessageBodyType_image;
                message.imageName = [tempChatDic objectForKey:@"LOCAL_FILENAME"];//本地地址LOCAL_FILENAME
                message.imageUrl=[ConverseTool formBase64Str:[tempChatDic objectForKey:@"CONTEXT"]];
                message.imageWidth = 150;
                message.imageHeight = 200;
                break;
            case 2:
                message.messageType = SHMessageBodyType_voice;
                message.voiceName = [tempChatDic objectForKey:@"LOCAL_FILENAME"];//本地地址LOCAL_FILENAME
                message.voiceDuration = @"0";//需要先下载
                message.voiceUrl=[ConverseTool formBase64Str:[tempChatDic objectForKey:@"CONTEXT"]];
                [self download:message];
               
                break;
            case 3:
                message.messageType = SHMessageBodyType_video;
                message.videoName = @"123";//需要先下载
                break;
             
            default:
                message = [self getTextMessage];
                break;
        }
       
        SHMessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:temp setTime:isLoad?loadTimeArr.lastObject:self.timeArr.lastObject];
        
        if (messageFrame) {//做添加
            if (messageFrame.showTime) {
                if (isLoad) {
                    [loadTimeArr addObject:message.sendTime];
                }else{
                    [self.timeArr addObject:message.sendTime];
                }
            }
            [temp addObject:messageFrame];
        }
    }
    
    if (loadTimeArr.count) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:0];
        for(int i=0;i<loadTimeArr.count;i++){
            [indexes addIndex:i];
        }
        [self.timeArr insertObjects:loadTimeArr atIndexes:indexes];
    }
    
    //更新已读状态
    [self sendReadedMessage:messageIds];
    return temp;
}
-(void)download:(SHMessage *)message{
    NSString *fileUrl=message.voiceUrl;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    
    NSURLSessionDownloadTask *downlaodTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //计算文件的下载进度
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //文件的全路径
        NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"APPData/Chat/Voice/AMR/%@",response.suggestedFilename]];
        
        ///APPData/Chat/Voice/AMR
        NSURL *fileUrl = [NSURL fileURLWithPath:fullpath];
        
        NSLog(@"%@\n%@",targetPath,fullpath);
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        NSString *result=[NSString stringWithFormat:@"%@",filePath];
        NSArray *temp=[result componentsSeparatedByString:@"/"];
        message.voiceName = [temp[temp.count-1] componentsSeparatedByString:@"."][0];//本地地址LOCAL_FILENAME
        message.voiceDuration = [NSString stringWithFormat:@"%d",[self audioSoundDuration:filePath]];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
         
    }];
    //3.执行Task
    [downlaodTask resume];
}
- (int)audioSoundDuration:(NSURL *)fileUrl {
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:options];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    int a; a = ceil(audioDurationSeconds);
    return a;
}
//更新已读状态
-(void)sendReadedMessage:(NSArray *) messageIds{
    
    if(messageIds.count>0){
        
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
        NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
        NSArray *resultArray =[dbh selectDataBase:chatDatabaseName tableName:@"CHAT_USER" columns:nil conditionColumns:@[@"FRIEND_ID"] values:@[self.model.FRIEND_ID] orderBy:@"ID" offset:0 limit:1];
        if(resultArray.count>0){
            //user表未读数
            NSInteger unreadNumber=[[resultArray[0] objectForKey:@"UNREAD"] integerValue];
            [dbh asyUpdateTable:chatDatabaseName tableName:@"CHAT_USER" columns:@[@"UNREAD"] conditionColumns:@[@"FRIEND_ID"] values:@[@[[NSString stringWithFormat:@"%ld",(unreadNumber-messageIds.count)],self.model.FRIEND_ID]]];
        }
        //chat表未读数
        NSMutableArray *temp=[NSMutableArray new];
        for(NSString *messageId in messageIds){
            [temp addObject:@[@"0",messageId]];
        }
        [dbh asyUpdateTable:chatDatabaseName tableName:@"CHAT_TABLE" columns:@[@"READ_STATUS"] conditionColumns:@[@"MI"] values:temp];
        
        
        [UIApplication sharedApplication].applicationIconBadgeNumber -= messageIds.count;
        LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
        //user list by group
        NSMutableDictionary *socketParam=[[NSMutableDictionary alloc]init];
        [socketParam setObject:@"11" forKey:@"T"];
        [socketParam setObject:[messageIds componentsJoinedByString:@"|"] forKey:@"MI"];
        NSString  *paramStr=[NSString stringWithFormat:@"%@\n",[ConverseTool DataTOjsonString:socketParam]];
        [socketServe sendMessage:paramStr];
    }
}
#pragma mark 未读按钮点击
/*
- (void)unreadClick:(UIButton *)btn{
    
    NSLog(@"增加%ld条",(long)btn.tag);
    
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
    
    //获取数据
    NSArray *temp = [self loadMeaaageDataWithNum:btn.tag isLoad:YES];
    
    if (temp.count) {
        //插入数据
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temp.count)];
        [self.dataSource insertObjects:temp atIndexes:indexes];
        
        [self.chatTableView reloadData];
        //滚动到刷新位置
        [self tableViewScrollToIndex:temp.count];
    }
    
    [self configUnread:0];
    
}
*/
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHMessageFrame *messageFrame = self.dataSource[indexPath.row];
    return messageFrame.cell_h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SHMessageFrame *messageFrame = self.dataSource[indexPath.row];
    
    NSString *reuseIdentifier = @"SHMessageTableViewCell";
    
    switch (messageFrame.message.messageType) {
        case SHMessageBodyType_text://文本
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHTextTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_voice://语音
        { 
            reuseIdentifier = [NSString stringWithFormat:@"SHVoiceTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_location://位置
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHLocationTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_image://图片
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHImageTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_note://通知
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHNoteTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_card://名片
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHCardTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHGifTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHRedPaperTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        case SHMessageBodyType_video://视频
        {
            reuseIdentifier = [NSString stringWithFormat:@"SHVideoTableViewCell_%@",messageFrame.message.messageId];
        }
            break;
        default:
            break;
    }
    
    SHMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        NSString *cellType=[reuseIdentifier componentsSeparatedByString:@"_"][0];
        cell = [[NSClassFromString(cellType) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
    }
    
    cell.messageFrame = messageFrame;
    
    return cell;
}

#pragma mark - ScrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
}


#pragma mark - SHMessageInputViewDelegate

-(void)sendMessage:(NSString *) messageText localFile:(NSString *)localFile MessageType:(NSNumber *) messageType {
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    NSMutableDictionary *socketParam=[[NSMutableDictionary alloc]init];
    [socketParam setObject:@"3" forKey:@"T"];
    [socketParam setObject:[ConverseTool getBase64Str:messageText] forKey:@"CT"];
    [socketParam setObject:[jbad.userInfoDic objectForKey:@"ROW_ID"] forKey:@"UI"];
    [socketParam setObject:[NSString stringWithFormat:@"%@",messageType] forKey:@"TP"];
    [socketParam setObject:self.model.FRIEND_ID forKey:@"FI"];
    [socketParam setObject:[jbad.userInfoDic objectForKey:@"USER_NAME"] forKey:@"UN"];
    [socketParam setObject:[jbad.userInfoDic objectForKey:@"IMG"] forKey:@"UH"];
    NSString  *paramStr=[NSString stringWithFormat:@"%@end==\n",[ConverseTool DataTOjsonString:socketParam]];
    [socketServe sendMessage:paramStr];
    [socketParam setObject:localFile forKey:@"LOCAL_FILENAME"];
    [self operateDatabase:socketParam flag:@"1"] ;
    
    
}
//insert into database
- (void)operateDatabase:(NSDictionary *)dic flag:(NSString *) flag
{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *values=[NSMutableArray new];
    [values addObject:self.model.FRIEND_ID];
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSArray *resultArray =[dbh selectDataBase:[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]] tableName:@"CHAT_USER" columns:nil conditionColumns:[NSArray arrayWithObjects:@"FRIEND_ID", nil] values:values orderBy:@"ID" offset:0 limit:1];
    
    NSMutableArray *columns=[NSMutableArray new];
    NSMutableArray *conditionColumns=[NSMutableArray new];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    values=[NSMutableArray new];
    //save user
    if([resultArray count]>0){
        //update
        [columns addObject:@"FRIEND_NAME"];
        [columns addObject:@"FRIEND_IMAGE"];
        [columns addObject:@"ISONLINE"];
        [columns addObject:@"ISGROUP"];
        [columns addObject:@"UNREAD"];
        [columns addObject:@"LAST_TIME"];
        [columns addObject:@"LAST_CONTEXT"];
        [columns addObject:@"UPDATE_TIME"];
        [columns addObject:@"FLAG"];
        
        [conditionColumns addObject:@"FRIEND_ID"];
        
        [values addObject:self.model.FRIEND_NAME];
        [values addObject:self.model.FRIEND_IMAGE!=nil?self.model.FRIEND_IMAGE:@""];
        [values addObject:@"0"];
        [values addObject:@"1"];
        [values addObject:@"0"];
        [values addObject:[formatter stringFromDate:date]];
        if([[dic objectForKey:@"TP"] isEqual:@"0"]){
            [values addObject:[dic objectForKey:@"CT"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"1"]){
            [values addObject:[ConverseTool getBase64Str:@"[图片]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"2"]){
            [values addObject:[ConverseTool getBase64Str:@"[语音]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"3"]){
            [values addObject:[ConverseTool getBase64Str:@"[视频]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"4"]){
            [values addObject:[ConverseTool getBase64Str:@"[文件]"]];
        }
        
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:[dic objectForKey:@"T"]];
        [values addObject:self.model.FRIEND_ID];
        
        [dbh updateTable:[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]] tableName:@"CHAT_USER" columns:columns conditionColumns:conditionColumns values:[NSArray arrayWithObjects:values, nil]];
    }else{
        //insert
        //[columns addObject:@"ID"];
        [columns addObject:@"FRIEND_ID"];
        [columns addObject:@"FRIEND_NAME"];
        [columns addObject:@"FRIEND_IMAGE"];
        [columns addObject:@"ISONLINE"];
        [columns addObject:@"ISGROUP"];
        [columns addObject:@"UNREAD"];
        [columns addObject:@"LAST_TIME"];
        [columns addObject:@"LAST_CONTEXT"];
        [columns addObject:@"UPDATE_TIME"];
        [columns addObject:@"FLAG"];
        [values addObject:self.model.FRIEND_ID];
        [values addObject:self.model.FRIEND_NAME];
        [values addObject:self.model.FRIEND_IMAGE];
        [values addObject:@"0"];
        [values addObject:@"1"];
        [values addObject:@"0"];
        [values addObject:[formatter stringFromDate:date]];
        if([[dic objectForKey:@"TP"] isEqual:@"0"]){
            [values addObject:[dic objectForKey:@"CT"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"1"]){
            [values addObject:[ConverseTool getBase64Str:@"[图片]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"2"]){
            [values addObject:[ConverseTool getBase64Str:@"[语音]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"3"]){
            [values addObject:[ConverseTool getBase64Str:@"[视频]"]];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"4"]){
            [values addObject:[ConverseTool getBase64Str:@"[文件]"]];
        }
        
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:[dic objectForKey:@"T"]];
        
        
        [dbh asyInsertTable:[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]] tableName:@"CHAT_USER" columns:columns values:[NSArray arrayWithObjects:values, nil]];
        
    }
    
    //sava message
    columns=[NSMutableArray new];
    conditionColumns=[NSMutableArray new];
    values=[NSMutableArray new];
    //聊天信息
    [columns addObject:@"FRIEND_ID"];
    [values addObject:self.model.FRIEND_ID];
    [columns addObject:@"CHAT_TYPE"];
    [values addObject:@"0"];
    [columns addObject:@"CONTENT_TYPE"];
    [values addObject:[dic objectForKey:@"TP"]];
    [columns addObject:@"CONTEXT"];
    [values addObject:[dic objectForKey:@"CT"]];
    [columns addObject:@"ADD_TIME"];
    [values addObject:[formatter stringFromDate:date]];
    [columns addObject:@"SEND_STATUS"];
    [values addObject:@"0"];
    [columns addObject:@"READ_STATUS"];
    [values addObject:@"0"];
    [columns addObject:@"FLAG"];
    [values addObject:@"0"];
    [columns addObject:@"TITLE"];
    [values addObject:self.model.FRIEND_NAME];
    [columns addObject:@"MI"];
    [values addObject:  [NSString stringWithFormat:@"%06d", (arc4random() % 100000)]];
    [columns addObject:@"MESSAGE_TYPE"];
    [values addObject:@"CHAT"];
    [columns addObject:@"LOCAL_FILENAME"];
    [values addObject:[dic objectForKey:@"LOCAL_FILENAME"]];
    
    
    [dbh asyInsertTable:[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]] tableName:@"CHAT_TABLE" columns:columns values:[NSArray arrayWithObjects:values, nil]];
   
    
}

#pragma mark 发送文本
- (void)chatMessageWithSendText:(NSString *)text{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_text;
    message.text = text;
    
    message.isRead = YES;
    message.messageRead = YES;
    message.messageState = SHSendMessageType_Successed;
    message.bubbleMessageType = 0;
    message.userId = self.model.FRIEND_ID;
    message.userName = self.model.FRIEND_NAME;
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    message.avator=[jbad.userInfoDic objectForKey:@"IMG"];
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
    [self sendMessage:text localFile:@"" MessageType:@0];
}

#pragma mark 发送图片
- (void)chatMessageWithSendImage:(UIImage *)image imageName:(NSString *)imageName size:(CGSize)size{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_image;
    message.imageName = imageName;
    message.image = image;
    message.userId = self.model.FRIEND_ID;
    message.userName = self.model.FRIEND_NAME;
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    message.avator=[jbad.userInfoDic objectForKey:@"IMG"];
    message.isRead = YES;
    message.messageRead = YES;
    message.messageState = SHSendMessageType_Delivering;
    message.bubbleMessageType = 0;
    //message.imageWidth = size.width;
    //message.imageHeight = size.height;
    message.imageWidth = 150;
    message.imageHeight = 200;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
    
    //[self sendMessage:url MessageType:@1];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self uploadFilesByMessage:message imageDatas:@[imageData] fileNames:@[imageName] fileTypes:@[@"image/png"]];
}

#pragma mark 发送视频
- (void)chatMessageWithSendVideo:(NSString *)videoName{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_video;
    message.videoName = videoName;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送语音
- (void)chatMessageWithSendVoice:(NSString *)voiceName duration:(NSString *)duration{
    
    //audio/amr
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_voice;
    message.userId = self.model.FRIEND_ID;
    message.userName = self.model.FRIEND_NAME;
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    message.avator=[jbad.userInfoDic objectForKey:@"IMG"];
    message.isRead = YES;
    message.messageRead = YES;
    message.messageState = SHSendMessageType_Delivering;
    message.bubbleMessageType = 0;
    message.voiceName = voiceName;
    message.voiceDuration = duration;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
    
    //NSString *wavfile = [SHFileHelper getFilePathWithName:voiceName type:SHMessageFileType_wav];
    //获取AMR文件路径
    NSString *amrFile = [SHFileHelper getFilePathWithName:voiceName type:SHMessageFileType_amr];
    //[self sendMessage:url MessageType:@1];
    NSData *data = [NSData dataWithContentsOfFile:amrFile];
    //NSData *imageData = UIImagePNGRepresentation(image);amrRecord.amr
    [self uploadFilesByMessage:message imageDatas:@[data] fileNames:@[[NSString stringWithFormat:@"%@.amr",voiceName]] fileTypes:@[@"audio/amr"]];
    
}
#pragma mark - 附件上传
- (void)uploadFilesByMessage:(SHMessage *)message imageDatas:(NSArray *) imageDatas fileNames:(NSArray *)filenames fileTypes:(NSArray *) fileTypes{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSData *imageData = UIImagePNGRepresentation(registerModel.idImage);
    NSDictionary *paramDic = @{@"project":@"edu"};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:jbad.urlUpload parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int index=0;index<[imageDatas count];index++){
            [formData appendPartWithFileData:imageDatas[index] name:@"files" fileName:filenames[index] mimeType:@""];
        }
    } error:nil]; 
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示进度
            //[self.progress setProgress:uploadProgress.fractionCompleted];
        });
    }
      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
          } else {
              NSDictionary *result=responseObject;
              if([[result objectForKey:@"status"] isEqualToString:@"0"]){
                  NSArray *tempArray=[result objectForKey:@"data"];
                  if([tempArray count]>0){
                      
                      if(message.messageType==SHMessageBodyType_image){
                          message.imageUrl=tempArray[0];
                          [self sendMessage:tempArray[0] localFile:filenames[0]  MessageType:@1];
                      }
                      else if(message.messageType==SHMessageBodyType_voice){
                          message.voiceUrl=tempArray[0];
                          [self sendMessage:tempArray[0] localFile:filenames[0]  MessageType:@2];
                      }
                  }
                  else{
                      [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
                  }
                  
              }
              else{
                  [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
              }
          }
      }];
    
    [uploadTask resume];
}
#pragma mark 发送位置
- (void)chatMessageWithSendLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_location;
    message.locationName = locationName;
    message.lon = lon;
    message.lat = lat;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送名片
- (void)chatMessageWithSendCard:(NSString *)card{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_card;
    message.card = card;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送通知
- (void)chatMessageWithSendNote:(NSString *)note{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_note;
    message.note = note;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送红包
- (void)chatMessageWithSendRedPackage:(NSString *)redPackage{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_redPaper;
    message.redPackage = redPackage;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送动图
- (void)chatMessageWithSendGif:(NSString *)gifName size:(CGSize)size{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_gif;
    message.gifName = gifName;
    message.gifWidth = size.width;
    message.gifHeight = size.height;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 获取文本
- (SHMessage *)getTextMessage{
    SHMessage *message = [SHMessageHelper addPublicParameters];
    message.messageType = SHMessageBodyType_text;
    message.text = @"GitHub：https://github.com/CCSH";
    return message;
}

#pragma mark 获取图片
- (SHMessage *)getImageMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_image;
    message.imageName = @"headImage.jpeg";
    message.imageUrl=@"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
    message.imageWidth = 150;
    message.imageHeight = 200;
    
    return message;
}

#pragma mark 获取视频
- (SHMessage *)getVideoMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_video;
    message.videoName = @"123";
    
    return message;
}

#pragma mark 获取语音
- (SHMessage *)getVoiceMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_voice;
    message.voiceName = [NSString stringWithFormat:@"%u",arc4random()%1000000];
    message.voiceDuration = @"2";
    
    return message;
}

#pragma mark 获取位置
- (SHMessage *)getLocationMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_location;
    message.locationName = @"中国";
    message.lon = 120.21937542;
    message.lat = 30.25924446;
    
    return message;
}

#pragma mark 获取名片
- (SHMessage *)getCardMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_card;
    message.card = @"哦哦";
    
    return message;
}

#pragma mark 获取通知
- (SHMessage *)getNoteMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_note;
    message.note = @"我的Github地址 https://github.com/CCSH 欢迎关注";
    
    message.messageState = SHSendMessageType_Successed;
    
    return message;
}

#pragma mark 获取红包
- (SHMessage *)getRedPackageMessagee{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_redPaper;
    message.redPackage = @"恭喜发财";
    
    return message;
}

#pragma mark 获取动图
- (SHMessage *)getGifMessage{
    
    SHMessage *message = [SHMessageHelper addPublicParameters];
    
    message.messageType = SHMessageBodyType_gif;
    message.gifName = @"诱惑.gif";
    message.gifWidth = 100;
    message.gifHeight = 100;
    
    return message;
}



#pragma mark 工具栏高度改变
- (void)toolbarHeightChange{
    
    //改变聊天界面高度
    CGRect frame = self.chatTableView.frame;
    frame.size.height = self.chatInputView.y-kNavBarHeight;
    self.chatTableView.frame = frame;
    [self.view layoutIfNeeded];
    //滚动到底部
    [self tableViewScrollToBottom];
}

#pragma mark - SHChatMessageCellDelegate
- (void)didSelectWithCell:(SHMessageTableViewCell *)cell type:(SHMessageClickType)type message:(SHMessage *)message{
    
    self.selectCell = cell;
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
    
    switch (type) {
        case SHMessageClickType_click_message://点击消息
        {
            NSLog(@"点击消息");
            //点击消息
            [self didSelectMessageWithMessage:message];
        }
            break;
        case SHMessageClickType_long_message://长按消息
        {
            NSLog(@"长按消息");
            //设置菜单内容
            NSArray *menuArr = [self getMenuControllerWithMessage:message];
            //显示菜单
            [SHMenuController showMenuControllerWithView:cell menuArr:menuArr showPiont:cell.tapPoint];
            
            cell.tapPoint = CGPointZero;
        }
            break;
        case SHMessageClickType_click_head://点击头像
        {
            NSLog(@"点击头像");
        }
            break;
        case SHMessageClickType_long_head://长按头像
        {
            NSLog(@"长按头像");
        }
            break;
        case SHMessageClickType_click_retry://点击重发
        {
            NSLog(@"点击重发");
            [self resendChatMessageWithMessageId:message.messageId];
        }
            break;
        default:
            break;
    }
}

#pragma mark 点击消息处理
- (void)didSelectMessageWithMessage:(SHMessage *)message{
    
    //判断消息类型
    switch (message.messageType) {
        case SHMessageBodyType_image://图片
        {
            NSLog(@"点击了 --- 图片消息");
            UIImageView *chatImageView = [[UIImageView alloc]init];
            NSString *filePath = [SHFileHelper getFilePathWithName:message.imageName type:SHMessageFileType_image];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image) {//本地
                [chatImageView setImage:image];
                ImageZoomView *imageZoomView=[[ImageZoomView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andWithImage: chatImageView];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:imageZoomView];
            }else{//网络
                //[chatImageView sd_setImageWithURL:[NSURL URLWithString:message.imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
            }
             
            
        }
            break;
        case SHMessageBodyType_voice://语音
        {
            NSLog(@"点击了 --- 语音消息");
            SHAudioPlayerHelper *audio = [SHAudioPlayerHelper shareInstance];
            audio.delegate = self;
            SHVoiceTableViewCell *cell = (SHVoiceTableViewCell *)self.selectCell;
            
            if (cell.isPlaying) {
                //正在播放
                cell.isPlaying = NO;
                [audio stopAudio];//停止
            }else{
                //未播放
                cell.isPlaying = YES;
                [audio managerAudioWithFileArr:@[message] isClear:YES];
            }
        }
            break;
        case SHMessageBodyType_location://位置
        {
            NSLog(@"点击了 --- 位置消息");
            //跳转地图界面
            SHChatMessageLocationViewController *location = [[SHChatMessageLocationViewController alloc]init];
            location.message = message;
            location.locType = SHMessageLocationType_Look;
            [self.navigationController pushViewController:location animated:YES];
        }
            break;
        case SHMessageBodyType_video://视频
        {
            NSLog(@"点击了 --- 视频消息");
            //本地路径
            NSString *videoPath = [SHFileHelper getFilePathWithName:message.videoName type:SHMessageFileType_video];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {//如果本地路径存在
                
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
                AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                playerViewController.player = player;
                [self.navigationController pushViewController:playerViewController animated:YES];
                [playerViewController.player play];
                
            }else{//使用URL
                
                if (message.videoUrl.length) {
                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:message.videoUrl]];
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    playerViewController.player = player;
                    [self.navigationController pushViewController:playerViewController animated:YES];
                    [playerViewController.player play];
                }
            }
        }
            break;
        case SHMessageBodyType_card://名片
        {
            NSLog(@"点击了 --- 名片消息");
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            NSLog(@"点击了 --- 红包消息");
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            NSLog(@"点击了 --- gif消息");
        }
            break;
        default:
            break;
    }
    
    //修改消息状态
    message.messageRead = YES;
}

#pragma mark 获取长按菜单内容
- (NSArray *)getMenuControllerWithMessage:(SHMessage *)message{
    
    //初始化列表
    if (!_copyMenuItem) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItem)];
    }
    if (!_deleteMenuItem) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem)];
    }
    
    NSMutableArray *menuArr = [[NSMutableArray alloc]init];
    //复制
    if (message.messageType == SHMessageBodyType_text) {//文本有复制
        //添加复制
        [menuArr addObject:_copyMenuItem];
    }
    //添加删除
    //[menuArr addObject:_deleteMenuItem];
    
    return menuArr;
}

#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark 下方菜单点击
- (void)didSelecteMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index{
    
    if ([menuItem.title isEqualToString:@"照片"]){
        
        [self.chatInputView openPhoto];
    }else if ([menuItem.title isEqualToString:@"拍摄"]){
        
        [self.chatInputView openCarema];
    }else if ([menuItem.title isEqualToString:@"位置"]){
        
        [self.chatInputView openLocation];
    }else if ([menuItem.title isEqualToString:@"名片"]){
        
        [self.chatInputView openCard];
    }else if ([menuItem.title isEqualToString:@"红包"]) {
        
        [self.chatInputView openRedPaper];
    }
}

#pragma mark - 长按菜单内容点击
#pragma mark 复制
- (void)copyItem{
    [UIPasteboard generalPasteboard].string = self.selectCell.messageFrame.message.text;
}

#pragma mark 删除
- (void)deleteItem{
    NSLog(@"删除");
    
    //删除消息
    [self deleteChatMessageWithMessageId:self.selectCell.messageFrame.message.messageId];
}

#pragma mark - SHAudioPlayerHelperDelegate
#pragma mark 开始播放
- (void)didAudioPlayerBeginPlay:(NSString *)playerName{
    
    for (SHVoiceTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell isKindOfClass:[SHVoiceTableViewCell class]]) {
            if ([cell.messageFrame.message.voiceName isEqualToString:playerName]) {
                [cell playVoiceAnimation];
            }else{
                [cell stopVoiceAnimation];
            }
        }
    }
}

#pragma mark 结束播放
- (void)didAudioPlayerStopPlay:(NSString *)playerName error:(NSString *)error{
    
    for (SHVoiceTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell isKindOfClass:[SHVoiceTableViewCell class]]) {
            if ([cell.messageFrame.message.voiceName isEqualToString:playerName]) {
                [cell stopVoiceAnimation];
            }
        }
    }
}

#pragma mark 暂停播放
- (void)didAudioPlayerPausePlay:(NSString *)playerName{
    for (SHVoiceTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell isKindOfClass:[SHVoiceTableViewCell class]]) {
            if ([cell.messageFrame.message.voiceName isEqualToString:playerName]) {
                [cell stopVoiceAnimation];
            }
        }
    }
}

#pragma mark - 数据处理
#pragma mark 添加到下方聊天界面
- (void)addChatMessageWithMessage:(SHMessage *)message isBottom:(BOOL)isBottom{
    
    if (message.messageState == SHSendMessageType_Delivering) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            message.messageState = SHSendMessageType_Successed;
            [self addChatMessageWithMessage:message isBottom:NO];
        });
    }
    
    //判断是否重复
    SHMessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:self.dataSource  setTime:self.timeArr.lastObject];
    
    if (messageFrame) {//做添加
        
        if (messageFrame.showTime) {
            [self.timeArr addObject:message.sendTime];
        }
        
        [self.dataSource addObject:messageFrame];
    }
    
    [self.chatTableView reloadData];
    
    if (isBottom) {
        //滚动到底部
        [self tableViewScrollToBottom];
    }
}

#pragma mark 处理数据属性
- (SHMessageFrame *)dealDataWithMessage:(SHMessage *)message dateSoure:(NSMutableArray *)dataSoure setTime:(NSString *)setTime{
    
    SHMessageFrame *messageFrame = [[SHMessageFrame alloc]init];
    
    //是否需要添加
    __block BOOL isAdd = YES;
    
    //为了判断是否有重复的数据
    [dataSoure enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([message.messageId isEqualToString:obj.message.messageId]) {//同一条消息
            *stop = YES;
            
            if ([message.sendTime isEqualToString:obj.message.sendTime]) {//时间相同做刷新
                
                isAdd = NO;
                
                messageFrame.showTime = obj.showTime;
                messageFrame.showName = obj.showName;
                
                [messageFrame setMessage:message];
                [dataSoure replaceObjectAtIndex:idx withObject:messageFrame];
                
            }else{//时间不同做添加
                
                [dataSoure removeObject:obj];
            }
        }
    }];
    
    //已经更新则不用进行处理
    if (isAdd) {
        
        //是否显示时间
        messageFrame.showTime = [SHMessageHelper isShowTimeWithTime:message.sendTime setTime:setTime];
        
        [messageFrame setMessage:message];
        return messageFrame;
    }
    
    return nil;
}

#pragma mark 删除聊天消息消息
- (void)deleteChatMessageWithMessageId:(NSString *)messageId{
    
    //删除此条消息
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        if ([obj.message.messageId isEqual:messageId]) {
            *stop = YES;
            
            //删除数据源
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
        }
    }];
    
    [self.chatTableView reloadData];
}

#pragma mark 重发聊天消息消息
- (void)resendChatMessageWithMessageId:(NSString *)messageId{
    
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.message.messageId isEqualToString:messageId]) {
            *stop = YES;
            
            //删除之前数据
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
            
            //添加公共配置
            SHMessage *model = [SHMessageHelper addPublicParametersWithMessage:obj.message];
            
            //模拟数据
            model.messageState = SHSendMessageType_Successed;
            model.bubbleMessageType = SHBubbleMessageType_Sending;
            //添加消息到聊天界面
            [self addChatMessageWithMessage:model isBottom:YES];
        }
    }];
}

#pragma mark 处理时间操作
- (void)dealTimeMassageDataWithCurrent:(SHMessageFrame *)current idx:(NSInteger)idx{
    
    //操作的此条是显示时间的
    if (current.showTime) {
        if (self.dataSource.count > idx) {//操作的是中间的
            
            SHMessageFrame *frame = self.dataSource[idx];
            
            [self.timeArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:current.message.sendTime]) {
                    *stop = YES;
                    [self.timeArr replaceObjectAtIndex:idx withObject:frame.message.sendTime];
                }
            }];
            
            frame.showTime = YES;
            //重新计算高度
            [frame setMessage:frame.message];
            [self.dataSource replaceObjectAtIndex:idx withObject:frame];
            
        }else{//操作的是最后一条
            [self.timeArr removeObject:current.message.sendTime];
        }
    }
}

#pragma mark - 界面滚动
#pragma mark 处理是否滚动到底部
- (void)dealScrollToBottom{
    
    if (self.dataSource.count > 1) {
        
        //整个tableview的倒数第二个cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 2 inSection:0];
        SHMessageTableViewCell *lastCell = (SHMessageTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
        
        CGRect last_rect = [lastCell convertRect:lastCell.frame toView:self.chatTableView];
        
        if (last_rect.size.width) {
            //滚动到底部
            [self tableViewScrollToBottom];
        }
    }
}
#pragma mark 滚动最上方
- (void)tableViewScrollToTop{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:0];
}

#pragma mark 滚动最下方
- (void)tableViewScrollToBottom{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:self.dataSource.count - 1];
}

#pragma mark 滚动到指定位置
- (void)tableViewScrollToIndex:(NSInteger)index{
    
    @synchronized (self.dataSource) {
        
        if (self.dataSource.count > index) {
            
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    
    if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
        newFrame.origin.y -= kSHBottomSafe;
    }
    self.chatInputView.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark - 懒加载
#pragma mark 背景图片
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        //设置背景
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        //_bgImageView.image = [SHFileHelper imageNamed:@"message_bg.jpeg"];
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bgImageView;
}

#pragma mark 聊天界面
- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kSHWidth, self.chatInputView.y-kNavBarHeight) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        
        _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _chatTableView;
}

#pragma mark 下方输入框
- (SHMessageInputView *)chatInputView{
    
    if (!_chatInputView) {
        _chatInputView = [[SHMessageInputView alloc]init];
        _chatInputView.frame = CGRectMake(0, self.view.height - kSHInPutHeight - kSHBottomSafe, kSHWidth, kSHInPutHeight);
        _chatInputView.delegate = self;
        _chatInputView.supVC = self;
        
        //图标
        //NSArray *plugIcons = @[@"sharemore_pic.png", @"sharemore_video.png",@"sharemore_voipvoice.png", @"sharemore_location.png",  @"sharemore_myfav.png", @"sharemore_friendcard.png"];
        //标题
        //NSArray *plugTitle = @[@"照片", @"拍摄", @"通话", @"位置", @"红包", @"名片"];
        //图标
        NSArray *plugIcons = @[@"sharemore_pic.png", @"sharemore_video.png"];
        //标题
        NSArray *plugTitle = @[@"照片", @"拍摄"];
        
        // 添加第三方接入数据
        NSMutableArray *shareMenuItems = [NSMutableArray array];
        
        //配置Item按钮
        [plugIcons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop)  {
            
            SHShareMenuItem *shareMenuItem = [[SHShareMenuItem alloc] initWithIcon:[SHFileHelper imageNamed:obj] title:plugTitle[idx]];
            [shareMenuItems addObject:shareMenuItem];
        }];
        
        _chatInputView.shareMenuItems = shareMenuItems;
        [_chatInputView reloadView];
        
        if (kSHBottomSafe) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(0, _chatInputView.maxY, kSHWidth, kSHBottomSafe);
            view.backgroundColor = kInPutViewColor;
            [self.view addSubview:view];
        }
    }
    return _chatInputView;
}

#pragma mark 时间集合
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [[NSMutableArray alloc]init];
    }
    return _timeArr;
}

#pragma mark 加载
- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(loadChatData) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}


#pragma mark - VC界面周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    jbad.isChatPage=@0;
    jbad.chatUserId=self.model.FRIEND_ID;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.selectCell = nil;
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    jbad.isChatPage=@1;
    jbad.chatUserId=@"";
}
 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 销毁
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
