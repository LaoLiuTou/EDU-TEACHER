//
//  ContactVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/18.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ContactVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "LTSearchBar.h"
#import "DataBaseHelper.h"

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "SHChatMessageViewController.h"
#import "StudentVC.h"
#import "ScanRegisterVC.h"
@interface ContactVC ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,ContactDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;

@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    [self.view addSubview:self.addSearchBar];
    _isEdit=NO;
     
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getNetworkData:@""];
    [self getRegisterData];
}
 
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLineHidden=YES;
   self.gk_navTitleColor=[UIColor whiteColor];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"通讯录";
    
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"tongxl-sq"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick)];
       
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    
    UIGraphicsBeginImageContextWithOptions(reSize, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
    
//    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
//    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (void)rightBarClick {
    ScanRegisterVC *jumpVC=[[ScanRegisterVC alloc] init];
    [self.navigationController pushViewController:jumpVC animated:YES];
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
    [self getNetworkData:searchBar.text];
    searchBar.showsCancelButton = YES;
    [self.view endEditing:YES];
    //收起键盘后取消无效
    self.searchBar.cancleButton.enabled=YES;
    
}
#pragma mark - 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    _isEdit=NO;
     [self getNetworkData:searchBar.text];
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-TabBarHeight)];
       
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
    
    
    
    if([[_sectionArray[section] objectForKey:@"NM_T"] isEqualToString:@"重点关注"]){
       
        [foldImageVie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(30);
            make.width.mas_equalTo(kWidth-40);
            make.height.mas_equalTo(50);
        }];
  
    }
    else{
        
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
    }
    
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
    [cell initViewWithModel:model status:model.STATUS];
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
-(void)getNetworkData:(NSString *)keyword{
    
    _listDataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"keyword":keyword};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryMailList"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            resultDic=[resultDic objectForKey:@"Result"];
            if([resultDic count]>0){
                
                NSArray *classArray=[resultDic objectForKey:@"cl_info"];
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
                
                NSDictionary *specilArray=[resultDic objectForKey:@"att_info"];
                if([[specilArray objectForKey:@"att_list"] count]>0){
                    
                    NSMutableDictionary *temp=[NSMutableDictionary new];
                    [temp setObject:@"" forKey:@"ID"];
                    [temp setObject:@"重点关注" forKey:@"NM_T"];
                    [temp setObject:[specilArray objectForKey:@"att_count"] forKey:@"STU_COUNT"];
                    [temp setObject:@"" forKey:@"FD_NAME"];
                    [temp setObject:@"extend" forKey:@"EXTEND"];
                    [self.sectionArray insertObject:temp atIndex:0];
                    [self.listDataArray insertObject:[specilArray objectForKey:@"att_list"] atIndex:0];
                } 
            }
            else{
                
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
#pragma mark - 是否有未审核的注册申请
-(void)getRegisterData{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:@"" forKey:@"keyword"];
    [paramDic setObject:@"1" forKey:@"page"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentRegistList"];
      
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            if([resultArray count]>0){
                
                 self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"tongxl-sqxx"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick)];
            }
            else{
                self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"tongxl-sq"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick)];
            }

        }
        else{
            
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"请求失败----%@", error);
       
    }];
    
}
@end
