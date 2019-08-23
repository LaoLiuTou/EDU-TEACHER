//
//  MessageVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MessageVC.h"
#import "DEFINE.h" 
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "LTSearchBar.h"
#import "DataBaseHelper.h"
#import "SHChatMessageViewController.h"
#import "SysMessageVC.h"
@interface MessageVC ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;

@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    //[self.view addSubview:self.addSearchBar];
     _isEdit=NO;
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
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitleColor=[UIColor whiteColor];
    self.gk_navTitle=@"消息";
}


#pragma mark - 添加搜索条
- (LTSearchBar *)addSearchBar {
    //加上 搜索栏
    self.searchBar= [[LTSearchBar alloc] initWithFrame:CGRectMake(10,kNavBarHeight+5, kWidth-20 , 40)];
    self.searchBar.isChangeFrame=NO;
    self.searchBar.showCancel=YES;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    //输入框提示
    self.searchBar.placeholder = @"搜索";
    //光标颜色
    self.searchBar.cursorColor = [UIColor darkGrayColor];
    //TextField
    self.searchBar.searchBarTextField.layer.cornerRadius = 4;
    self.searchBar.searchBarTextField.layer.masksToBounds = YES;
    self.searchBar.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchBar.searchBarTextField.layer.borderWidth = 1.0;
    self.searchBar.searchBarTextField.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    //清除按钮图标
    self.searchBar.clearButtonImage = [UIImage imageNamed:@"deleteicon_channel"];
    //去掉取消按钮灰色背景
    self.searchBar.hideSearchBarBackgroundImage = YES;
    _isEdit=NO;
    return self.searchBar;
}
#pragma mark - 已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    LTSearchBar *sear = (LTSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _isEdit=YES;
    
}

#pragma mark - 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}
#pragma mark - 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
}
#pragma mark - 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    _isEdit=NO;
    
    
}


#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}
- (void)refreshMessage:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    [self getLocalData];
    
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-50)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight, kWidth, kHeight-kNavBarHeight-TabBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70.0f;
    }
    return _tableView;
}


#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.ID];
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
     
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell initViewWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageModel *model=_listDataArray[indexPath.row];
    if([model.FLAG isEqualToString:@"3"]){
        SHChatMessageViewController *chatView= [[SHChatMessageViewController alloc] init];
        chatView.model=model;
        [self.navigationController pushViewController:chatView animated:YES];
    }
    else{
        
        [self.navigationController pushViewController:[SysMessageVC new] animated:YES];
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
            MessageModel *model=self.listDataArray[indexPath.row] ;
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
    NSArray *tempArray=[dbh selectAllTable:chatDatabaseName tableName:@"CHAT_USER" order:@"UPDATE_TIME DESC"];
    /////
    bool isSysMsg=false;
    for(NSDictionary *tempDic in tempArray){
        MessageModel *model=[[MessageModel alloc] initWithDic:tempDic];
//        if([model.FLAG isEqualToString:@"7"]){
//            [self.listDataArray insertObject:model atIndex:0];
//        }
//        else{
//           [self.listDataArray addObject:model];
//        }
        
        if([model.FLAG isEqualToString:@"7"]){
            if(!isSysMsg){
                model.FRIEND_NAME=@"系统消息";
                [self.listDataArray insertObject:model atIndex:0];
                isSysMsg=true;
            }
            
        }
        else{
            
            [self.listDataArray addObject:model ];
           
        }
        
    }
    [self.tableView reloadData];
    //NSLog(@"%@",_listDataArray);
    
}

-(void)deleteChatUser:(MessageModel *)model{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
    [dbh deleteTable:chatDatabaseName tableName:@"CHAT_USER" conditionColumns:@[@"FRIEND_ID"] values:@[model.FRIEND_ID]];
    [dbh deleteTable:chatDatabaseName tableName:@"CHAT_TABLE" conditionColumns:@[@"FRIEND_ID"] values:@[model.FRIEND_ID]];
}
@end
