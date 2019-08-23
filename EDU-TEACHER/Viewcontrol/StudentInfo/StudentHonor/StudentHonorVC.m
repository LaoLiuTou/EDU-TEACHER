//
//  StudentHonorVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentHonorVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "StudentHonorModel.h"
#import "StudentHonorCell.h"
#import "AddStudentHonorVC.h"
#import "StudentAttentDetailVC.h"
@interface StudentHonorVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@end


@implementation StudentHonorVC{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    //刷新加载
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page=1;
        self->_listDataArray=@[].mutableCopy;
        [weakSelf getNetworkData:self->page];
    }];
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [weakSelf getNetworkData:self->page];
    }];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    self->_listDataArray=@[].mutableCopy;
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"chengjisuoqi"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick)];
    
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"荣誉奖励";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContextWithOptions(reSize, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick {
    AddStudentHonorVC *jumpVC=[AddStudentHonorVC new];
    jumpVC.xs_id=self.xs_id;
    jumpVC.xs_name=self.xs_name;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=GKColorRGB(246, 246, 246);
    [self.view addSubview:self.tableView];
    
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight+6, kWidth, kHeight-kNavBarHeight-6)];
        
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
    StudentHonorModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    
    StudentHonorCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[StudentHonorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell initViewWithModel:model];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
}



- (void)delayMethod {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}



#pragma mark - 网络请求获取数据
-(void)getNetworkData:(int)page{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentRyList"];
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"page":[NSString stringWithFormat:@"%d",page],@"xs_id":self.xs_id};
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            for (NSDictionary *item in resultArray) {
                
                StudentHonorModel *model=[[StudentHonorModel alloc] initWithDic:item];
                [self.listDataArray addObject:model];
            }
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
        [self delayMethod];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self delayMethod];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
}

@end
