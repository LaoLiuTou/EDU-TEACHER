//
//  SignInTableViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/20.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveTableViewController.h"
#import "DEFINE.h"
#import "MJRefresh.h"
#import "GKWBListViewController.h"
#import "LeaveListCell.h"
#import "LeaveListModel.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "LeaveDetailViewController.h"
@interface LeaveTableViewController ()<UITableViewDataSource, UITableViewDelegate,GKPageListViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation LeaveTableViewController{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initNavBar];
    
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
    
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[self.tableView.mj_header beginRefreshing];
}

#pragma mark - nav设置
- (void)initNavBar {
   self.gk_navigationBar.hidden = YES; 
}
#pragma mark - 初始化视图
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
       
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
 
       _tableView.rowHeight = 90.0f;
    }
    return _tableView;
}


#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listDataArray count];
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaveListModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"leaveListCell%@",model.id];
    
    LeaveListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[LeaveListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.xs_nameLabel setText:model.xs_name];
    [cell.typeLabel setText:model.type];
    if([model.type isEqualToString:@"病假"]){
        [cell.typeLabel setBackgroundColor:GKColorRGB(129 , 184 , 79)];
    }
    else if([model.type isEqualToString:@"事假"]){
        [cell.typeLabel setBackgroundColor:GKColorRGB(241 , 173 , 50)];
    }
 
    [cell.start_timeLabel setText:[NSString stringWithFormat:@"开始时间:%@",model.start_time]];
    [cell.end_timeLabel setText:[NSString stringWithFormat:@"结束时间:%@",model.end_time]];
    if([model.status isEqualToString:@"已驳回"]){
        [cell.statusLabel setText:@"已拒绝"];
    }
    else{
        [cell.statusLabel setText:model.status];
    }
    
    if([model.status isEqualToString:@"已通过"]&&![self.status isEqualToString:@"待销假"]){
        cell.statusLabel.textColor=GKColorHEX(0x2c92f5, 1);
        [cell.statusLabel setHidden:NO];
    }
    else if([model.status isEqualToString:@"已驳回"]&&![self.status isEqualToString:@"待销假"]){
        cell.statusLabel.textColor=[UIColor darkGrayColor];
        [cell.statusLabel setHidden:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeaveDetailViewController *detailVC= [[LeaveDetailViewController alloc] init];
    LeaveListModel *model=_listDataArray[indexPath.row];
    detailVC.detailId=model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(int)page{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"page":[NSString stringWithFormat:@"%d",page],@"status":_status};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryLeaveList"];
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            for (NSDictionary *item in resultArray) {
                
                LeaveListModel *model=[[LeaveListModel alloc] initWithDic:item];
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
 
//- (void)getNetworkData:(BOOL )isrefresh{
//    __weak typeof(self) weakSelf = self;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [weakSelf delayMethod];
//    });
//}
- (void)delayMethod {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewDidScroll = callback;
}

 

@end
