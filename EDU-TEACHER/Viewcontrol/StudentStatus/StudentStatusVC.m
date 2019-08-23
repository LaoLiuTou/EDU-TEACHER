//
//  StudentStatusVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/6.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentStatusVC.h"
 
#import "DEFINE.h" 
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "DataBaseHelper.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "SHChatMessageViewController.h"
#import "StudentVC.h"
@interface StudentStatusVC ()<UITableViewDataSource, UITableViewDelegate,ContactDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;

@end

@implementation StudentStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getNetworkData];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitleColor=[UIColor whiteColor];
    
    NSString *title=[NSString stringWithFormat:@"%@学生",self.status];
    self.gk_navTitle=title;
    
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
    //self.tableView.separatorColor = GKColorHEX(0xf7f7f7, 1);
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60.0f;
        self.tableView.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    }
    return _tableView;
}


#pragma mark - 数据
#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];//创建一个视图
    headerView.backgroundColor= [UIColor whiteColor];
    
    
    //折叠展开
    UIImageView *foldImageVie=[[UIImageView alloc] init];
    if ([[_sectionArray[section] objectForKey:@"EXTEND"] isEqualToString:@"extend"]) {
        [foldImageVie setImage:[UIImage imageNamed:@"zhankai-jt"]];
    } else {
        [foldImageVie setImage:[UIImage imageNamed:@"shouqi-jt"]];
    }
    [headerView addSubview:foldImageVie];
    foldImageVie.tag=10000+section;
    //标题
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textColor = [UIColor blackColor];
    if([[_sectionArray[section] objectForKey:@"NM_T"] isEqualToString:@"重点关注"]){
         headerLabel.text = [NSString stringWithFormat:@"%@ | %@人",[_sectionArray[section] objectForKey:@"NM_T"],[_sectionArray[section] objectForKey:@"STU_COUNT"]];
    }
    else{
        headerLabel.text = [NSString stringWithFormat:@"%@班 | %@人",[_sectionArray[section] objectForKey:@"NM_T"],[_sectionArray[section] objectForKey:@"STU_COUNT"]];
    }
    [headerView addSubview:headerLabel];
    
    if(section == 0){
        headerView.frame=CGRectMake(0, 0, kWidth, 50);
    }
    else{
        headerView.frame=CGRectMake(0, 0, kWidth, 56);
        //灰色线
        UIView *topLine= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 6)];
        topLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
        [headerView addSubview:topLine];
        
    }
    
    //辅导员
    UILabel *fdyLabel = [[UILabel alloc] init];
    fdyLabel.textColor = [UIColor grayColor];
    fdyLabel.font = [UIFont boldSystemFontOfSize:12.0];
    fdyLabel.text = [NSString stringWithFormat:@"辅导员:%@",[_sectionArray[section] objectForKey:@"FD_NAME"]];
    [headerView addSubview:fdyLabel];
    
    
    [foldImageVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).offset(3);
        make.left.equalTo(headerView).offset(15);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(section == 0){
            make.top.equalTo(headerView).offset(10);
        }
        else{
            make.top.equalTo(headerView).offset(15);
        }
        make.left.equalTo(headerView).offset(30);
        make.width.mas_equalTo(kWidth-40);
        make.height.mas_equalTo(20);
    }];
    [fdyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(section == 0){
            make.top.equalTo(headerView).offset(28);
        }
        else{
            make.top.equalTo(headerView).offset(32);
        }
        make.left.equalTo(headerView).offset(30);
        make.width.mas_equalTo(kWidth-40);
        make.height.mas_equalTo(20);
    }];
   
    
    headerView.tag=1000+section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}
- (void)sectionClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag%1000;
    NSMutableDictionary *temp=_sectionArray[index];
    if ([[temp objectForKey:@"EXTEND"] isEqualToString:@"extend"]) {
        [temp setObject:@"unextend" forKey:@"EXTEND"];
        
    } else {
        [temp setObject:@"extend" forKey:@"EXTEND"];
    }
    // 刷新单独一组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 50.0;
    }
    else{
        return 56.0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *temp=_sectionArray[section];
    if ([[temp objectForKey:@"EXTEND"] isEqualToString:@"extend"]) {
        return [_listDataArray[section] count];
    }
    else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempCellDic=_listDataArray[indexPath.section][indexPath.row];
    ContactModel *model=[[ContactModel alloc] initWithDic:tempCellDic];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    ContactCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate=self;
    [cell initViewWithModel:model status:self.status];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *tempCellDic=_listDataArray[indexPath.section][indexPath.row];
    ContactModel *model=[[ContactModel alloc] initWithDic:tempCellDic];
    MessageModel *messageModel=[[MessageModel alloc] init];
    messageModel.FRIEND_ID=model.USER_ID;
    messageModel.FRIEND_NAME=model.NM_T;
    messageModel.FRIEND_IMAGE=model.I_UPIMG;
    SHChatMessageViewController *chatView= [[SHChatMessageViewController alloc] init];
    chatView.model=messageModel;
    [self.navigationController pushViewController:chatView animated:YES];
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    
    _listDataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"status":self.status};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentListByStatus"];
    
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *classArray=[resultDic objectForKey:@"Result"];
            for (int i = 0; i < classArray.count; i++) { 
                //section
                NSMutableDictionary *temp=[NSMutableDictionary new];
                [temp setObject:[classArray[i] objectForKey:@"id"] forKey:@"ID"];
                [temp setObject:[classArray[i] objectForKey:@"NM_T"] forKey:@"NM_T"];
                [temp setObject:[classArray[i] objectForKey:@"xs_count"] forKey:@"STU_COUNT"];
                [temp setObject:[classArray[i] objectForKey:@"fd_name"] forKey:@"FD_NAME"];
                [temp setObject:@"extend" forKey:@"EXTEND"];
                [self.sectionArray addObject:temp];
                [self.listDataArray addObject:[classArray[i] objectForKey:@"xs_list"]];
            }
            
            [self.tableView reloadData];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
    
}
- (void)clickHeader:(UITapGestureRecognizer *)tap model:(ContactModel *)model {
    NSLog(@"%@",model);
    StudentVC *studentVC= [StudentVC new];
    studentVC.studentId=model.id;
    [self.navigationController pushViewController:studentVC animated:YES];
}

@end
