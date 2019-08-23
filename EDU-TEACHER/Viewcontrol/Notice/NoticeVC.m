//
//  NoticeVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/10.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoticeVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "NoticeModel.h"
#import "NoticeCell.h"
#import "AddNoticeVC.h"
#import "NoticeDetailVC.h"
@interface NoticeVC ()<UITableViewDataSource, UITableViewDelegate,NoticeCellDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@end

@implementation NoticeVC{
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
    
    self->_listDataArray=@[].mutableCopy;
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick)];
    
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"通知管理";
    self.gk_navTitleColor=[UIColor whiteColor];
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

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick {
    [self.navigationController pushViewController:[AddNoticeVC new] animated:YES];
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
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        
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
    NoticeModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    NoticeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.delegate = self;
    cell.notice=model;
    [cell.nameLabel setText:model.name];
    [cell.publish_timeLabel setText:model.publish_time];
    [cell.readLabel setText:[NSString stringWithFormat:@"%@/%@",model.yidu_count,model.all_count]];
    if([model.status isEqualToString:@"已发布"]){
        cell.statusBtn.backgroundColor=[UIColor whiteColor];
        [cell.statusBtn setTitle:model.status forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{ 
        cell.statusBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [cell.statusBtn setTitle:model.status forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDetailVC *detailVC=[NoticeDetailVC new];
    NoticeModel *model=_listDataArray[indexPath.row];
    detailVC.detailId=model.id;
    detailVC.status=model.status;
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)delayMethod {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}



- (void)clickPublishBtn:(UIButton *)btn notice:(NoticeModel *)notice {
    NSLog(@"%@",notice);
    if([notice.status isEqualToString:@"已发布"]){
    
    }
    else{
        [self publishNotice:notice.id];
    }
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(int)page{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"page":[NSString stringWithFormat:@"%d",page]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryTongzhiList"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            for (NSDictionary *item in resultArray) {
                
                NoticeModel *model=[[NoticeModel alloc] initWithDic:item];
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


#pragma mark - 网络请求获取数据
-(void)publishNotice:(NSString *)noticeId{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:noticeId forKey:@"id"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishTongzhi"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            [self.tableView.mj_header beginRefreshing];
            
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
}
@end
