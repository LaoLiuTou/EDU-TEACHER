//
//  SchoolReportVCViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/22.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SchoolReportVC.h"
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
@interface SchoolReportVC ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@end

@implementation SchoolReportVC


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
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"学生成绩";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    [self.view addSubview:self.tableView];
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    //self.tableView.separatorColor = GKColorHEX(0xf7f7f7, 1);
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight+6, kWidth, kHeight-kNavBarHeight-6)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 30.0f;
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
    
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    [headerView addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.backgroundColor=[UIColor whiteColor];
    nameLabel.font=[UIFont systemFontOfSize:16];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.text =[self.sectionArray[section] objectForKey:@"NM_T"];
    nameLabel.tag=100000+section;
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(22);
        make.center.equalTo(headerView);
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(20.0f);
    }];
    
    //折叠展开
    UIImageView *foldImageVie=[[UIImageView alloc] init];
    if ([[_sectionArray[section] objectForKey:@"EXTEND"] isEqualToString:@"extend"]) {
        [foldImageVie setImage:[UIImage imageNamed:@"chengjizhankai"]];
        nameLabel.textColor=GKColorHEX(0x2c92f5,1);
    } else {
        [foldImageVie setImage:[UIImage imageNamed:@"chengjisuoqi"]];
        nameLabel.textColor=[UIColor blackColor];
    }
    [headerView addSubview:foldImageVie];
    foldImageVie.tag=10000+section;
    [foldImageVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-20);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    UIView *bottomLine=[[UIView alloc] init];
    bottomLine.backgroundColor= GKColorHEX(0xf7f7f7, 1);
    [headerView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
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
    return 44.0;
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
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",[tempCellDic objectForKey:@"id"]];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@:%@", [tempCellDic objectForKey:@"lesson"],[tempCellDic objectForKey:@"score"]];
    cell.textLabel.textColor=[UIColor grayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSDictionary *tempCellDic=_listDataArray[indexPath.section][indexPath.row];
    
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    
    _listDataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"xs_id":self.xs_id};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentCj"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            if([resultArray count]>0){
                for (NSDictionary *cjArray in resultArray) {
                    //section
                    NSMutableDictionary *temp=[NSMutableDictionary new];
                    [temp setObject:[cjArray objectForKey:@"xueqi_name"] forKey:@"NM_T"];
                    [temp setObject:@"unextend" forKey:@"EXTEND"];
                    [self.sectionArray addObject:temp];
                    [self.listDataArray addObject:[cjArray objectForKey:@"chengji_list"]];
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

@end
