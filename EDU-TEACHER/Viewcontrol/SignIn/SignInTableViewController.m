//
//  SignInTableViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/20.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SignInTableViewController.h"
#import "DEFINE.h"
#import "MJRefresh.h"
#import "GKWBListViewController.h"
#import "SignInListCell.h"
#import "SignInModel.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "LeaveDetailViewController.h"
#import "OtherSignInDetailVC.h"
#import "ClassSignInDetailVC.h"
#import "DormSignInDetailVC.h"
#import "ActivitySignInDetailVC.h"
@interface SignInTableViewController ()<UITableViewDataSource, UITableViewDelegate,GKPageListViewDelegate,SignInCellDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, strong) NSIndexPath   *selectIndex;//点击的cell  刷新用
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation SignInTableViewController{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initNavBar];
    
    NSString *notiString = @"";
    if([_type isEqualToString:@"课程"]){
        notiString=@"refreshClassSignInListItem";
    }
    else if([_type isEqualToString:@"宿舍"]){
        notiString=@"refreshDormSignInListItem";
    }
    else if([_type isEqualToString:@"活动"]){
        notiString=@"refreshActivitySignInListItem";
    }
    else if([_type isEqualToString:@"其他"]){
        notiString=@"refreshOtherSignInListItem";
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSignInListItem:) name:notiString object:nil];
    
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
    if([_type isEqualToString:@"全部"]){
       [self.tableView.mj_header beginRefreshing];
    }
    //[self.tableView.mj_header beginRefreshing];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navigationBar.hidden = YES;
}

#pragma mark - 刷新cell 签到数
- (void)refreshSignInListItem:(NSNotification *)notification{
    SignInModel *model=_listDataArray[self.selectIndex.row];
    int count=[model.signed_count intValue];
    model.signed_count=[NSString stringWithFormat:@"%d",(count+1)];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectIndex,nil] withRowAnimation:UITableViewRowAnimationNone];
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
    SignInModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    SignInListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[SignInListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    [cell initView:model];
    
    [cell.nameLabel setText:model.name];
    if([model.type isEqualToString:@"课程签到"]||[_type isEqualToString:@"课程"]){
        [cell.typeLabel setText:@"课程"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(120 , 180 , 50)];
    }
    else if([model.type isEqualToString:@"宿舍签到"]||[_type isEqualToString:@"宿舍"]){
        [cell.typeLabel setText:@"宿舍"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(241 , 168 , 0)];
    }
    else if([model.type isEqualToString:@"活动签到"]||[_type isEqualToString:@"活动"]){
        [cell.typeLabel setText:@"活动"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(234 , 58 , 50)];
    }
    else if([model.type isEqualToString:@"其他签到"]||[_type isEqualToString:@"其他"]){
        [cell.typeLabel setText:@"其他"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(0 , 130 , 243)];
    }
    else{
        [cell.typeLabel setHidden:YES];
    }
        
    [cell.start_timeLabel setText:[NSString stringWithFormat:@"开始时间:%@",model.start_time]];
    [cell.end_timeLabel setText:[NSString stringWithFormat:@"结束时间:%@",model.end_time]];
     
    if([model.status isEqualToString:@"忽略"]||[model.status isEqualToString:@"待发起"]){
        [cell.statusButton setHidden:NO];
        [cell.statusLabel setHidden:YES];
        [cell.statusButton setTitle:[NSString stringWithFormat:@"  %@(%@/%@)  ",model.status,model.signed_count,model.all_count] forState:UIControlStateNormal];
    }
    //if([model.status isEqualToString:@"已结束"]||[model.status isEqualToString:@"已发起"]){
    else{
        [cell.statusLabel setHidden:NO];
        [cell.statusButton setHidden:YES];
        cell.statusLabel.text=[NSString stringWithFormat:@"%@(%@/%@)",model.status,model.signed_count,model.all_count];
    }
    cell.signin=model;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SignInModel *model=_listDataArray[indexPath.row];
    self.selectIndex=indexPath;
    if([model.type isEqualToString:@"课程签到"]||[_type isEqualToString:@"课程"]){
        ClassSignInDetailVC *jumpVC=[ClassSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"宿舍签到"]||[_type isEqualToString:@"宿舍"]){
        DormSignInDetailVC *jumpVC=[DormSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"活动签到"]||[_type isEqualToString:@"活动"]){
        ActivitySignInDetailVC *jumpVC=[ActivitySignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"其他签到"]||[_type isEqualToString:@"其他"]){
        OtherSignInDetailVC *jumpVC=[OtherSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
  
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(int)page{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    NSString *postUrl=@"";
    if([_type isEqualToString:@"全部"]){
        //[paramDic setObject:@"" forKey:@"keyword"];
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryAllSignList"];
    }
    else if([_type isEqualToString:@"课程"]){
        //修改
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryKqSignList"];
    }
    else if([_type isEqualToString:@"宿舍"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"querySsqSignList"];
    }
    else if([_type isEqualToString:@"活动"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryHqSignList"];
    }
    else if([_type isEqualToString:@"其他"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryJqSignList"];
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            for (NSDictionary *item in resultArray) {
                
                SignInModel *model=[[SignInModel alloc] initWithDic:item];
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
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
}


#pragma mark - 发起
-(void)publishSignIn:(SignInModel *)model{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:model.id forKey:@"id"];
    NSString *postUrl=@"";
    
    if([model.type isEqualToString:@"课程签到"]||[_type isEqualToString:@"课程"]){
       postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishKqSign"];
    }
    else if([model.type isEqualToString:@"宿舍签到"]||[_type isEqualToString:@"宿舍"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishSsqSign"];
    }
    else if([model.type isEqualToString:@"活动签到"]||[_type isEqualToString:@"活动"]){
       postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishHqSign"];
    }
    else if([model.type isEqualToString:@"其他签到"]||[_type isEqualToString:@"其他"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishJqSign"];
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"发起成功！"];
            [self.tableView.mj_header beginRefreshing];
        }
        else{
            [SVProgressHUD dismiss];
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
}


#pragma mark - 忽略
-(void)ignoreSignIn:(SignInModel *)model{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:model.id forKey:@"id"];
    NSString *postUrl=@"";
    
    if([model.type isEqualToString:@"课程签到"]||[_type isEqualToString:@"课程"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"finishKqSign"];
    }
    else if([model.type isEqualToString:@"宿舍签到"]||[_type isEqualToString:@"宿舍"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"finishSsqSign"];
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"已忽略签到！"];
            [self.tableView.mj_header beginRefreshing];
        }
        else{
            [SVProgressHUD dismiss];
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
    
}

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



- (void)clickStatusBtn:(UIButton *)btn signin:(SignInModel *)signin {
    NSLog(@"signin:%@",signin);
    if([signin.status isEqualToString:@"待发起"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要发起签到吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self publishSignIn:signin];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([signin.status isEqualToString:@"忽略"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要忽略这次签到吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self ignoreSignIn:signin];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
