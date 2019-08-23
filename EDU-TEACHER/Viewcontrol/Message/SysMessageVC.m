//
//  SysMessageVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/17.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SysMessageVC.h"
#import "DEFINE.h" 
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "SysMessageCell.h"
#import "SysMessageModel.h"
#import "DataBaseHelper.h"
#import "ConverseTool.h"



#import "ActivityDetailVC.h"
#import "NoticeDetailVC.h"
#import "ActivitySignInDetailVC.h"
#import "ClassSignInDetailVC.h"
#import "DormSignInDetailVC.h"
#import "OtherSignInDetailVC.h"
#import "LeaveDetailViewController.h" 
#import "NoteDetailVC.h"
@interface SysMessageVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;

@end

@implementation SysMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    //注册通知：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMessage:) name:@"RefreshMessage" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getLocalData];
}
- (void)viewWillDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLineHidden=YES;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitleColor=[UIColor blackColor];
    self.gk_navTitle=@"系统消息";
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=GKColorRGB(246, 246, 246);
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}
- (void)refreshMessage:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    [self getLocalData];
    
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80.0f;
    }
    return _tableView;
}


#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.ID];
    SysMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[SysMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell initViewWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SysMessageModel *model=_listDataArray[indexPath.row];
    //保存未读的messageId
    NSMutableArray *messageIds=[[NSMutableArray alloc]init];
    [messageIds addObject:model.MI];
    //更新已读状态
    [self sendReadedMessage:messageIds friendId:model.FRIEND_ID];
 
    
    if([model.MESSAGE_TYPE isEqualToString:@"activity"]){
        ActivityDetailVC *jumpVC= [ActivityDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"notice"]){
        NoticeDetailVC *jumpVC= [NoticeDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"courseSign"]){
        ClassSignInDetailVC *jumpVC= [ClassSignInDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"dormSign"]){
        DormSignInDetailVC *jumpVC= [DormSignInDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"activitySign"]){
        ActivitySignInDetailVC *jumpVC= [ActivitySignInDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"otherSign"]){
        OtherSignInDetailVC *jumpVC= [OtherSignInDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"leave"]){
        LeaveDetailViewController *jumpVC= [LeaveDetailViewController new];
        jumpVC.detailId=model.ITEM_ID;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"memo"]){
        NoteDetailVC *jumpVC= [NoteDetailVC new];
        jumpVC.detailId=model.ITEM_ID;
        jumpVC.noteType=@"工作备忘";
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.MESSAGE_TYPE isEqualToString:@"proveLeave"]){
        
    }
    else{
        
    }
    
}

//更新已读状态
-(void)sendReadedMessage:(NSArray *) messageIds friendId:(NSString *) friendId{
    
    if(messageIds.count>0){
        
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
        NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
        NSArray *resultArray =[dbh selectDataBase:chatDatabaseName tableName:@"CHAT_USER" columns:nil conditionColumns:@[@"FRIEND_ID"] values:@[friendId] orderBy:@"ID" offset:0 limit:1];
        if(resultArray.count>0){
            //user表未读数
            NSInteger unreadNumber=[[resultArray[0] objectForKey:@"UNREAD"] integerValue];
            [dbh asyUpdateTable:chatDatabaseName tableName:@"CHAT_USER" columns:@[@"UNREAD"] conditionColumns:@[@"FRIEND_ID"] values:@[@[[NSString stringWithFormat:@"%ld",(unreadNumber-messageIds.count)],friendId]]];
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
#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除该消息吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SysMessageModel *model=self.listDataArray[indexPath.row] ;
            [self.listDataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            NSLog(@"删除动作");
            [self deleteChatUser:model];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 本地聊天数据
-(void)getLocalData{
    self.listDataArray=[NSMutableArray new];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
  
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
     
    NSArray *tempArray=[dbh selectTable:chatDatabaseName tableName:@"CHAT_TABLE" columns:nil conditionColumns:@[@"FLAG"] values:@[@"7"] order:@"ADD_TIME DESC"];
    for(NSDictionary *tempDic in tempArray){
        SysMessageModel *model=[[SysMessageModel alloc] initWithDic:tempDic];
        
        [self.listDataArray addObject:model];
        
        
    }
    [self.tableView reloadData];
    NSLog(@"%@",_listDataArray);
    
}

-(void)deleteChatUser:(SysMessageModel *)model{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
    [dbh deleteTable:chatDatabaseName tableName:@"CHAT_TABLE" conditionColumns:@[@"MI"] values:@[model.ID]];
}
@end
