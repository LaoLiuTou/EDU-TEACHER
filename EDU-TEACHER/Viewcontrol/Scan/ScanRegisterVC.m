//
//  ScanRegisterVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/10/16.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ScanRegisterVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "ScanRegisterModel.h"
#import "ScanRegisterCell.h"
#import "LTSearchBar.h"
@interface ScanRegisterVC ()<UITableViewDataSource, UITableViewDelegate,ScanRegisterCellDelegate,UISearchBarDelegate>
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@end

@implementation ScanRegisterVC{
     int page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit=NO;
    [self initNavBar];
    [self initView];
    [self.view addSubview:self.addSearchBar];
     
    //刷新加载
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page=1;
        self->_dataArray=@[].mutableCopy;
        [weakSelf getNetworkData:@"" page:self->page];
    }];
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [weakSelf getNetworkData:@"" page:self->page];
    }]; 
    self->_dataArray=@[].mutableCopy;
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:@"一键同意 "  image:nil target:self action:@selector(rightBarClick:)];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"扫码申请";
    self.gk_navTitleColor=[UIColor whiteColor];
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
- (void)rightBarClick:(UIBarButtonItem *)sender {
    //同意全部
    [self agreenRejectRecord:@"-1" state:@"1"];
}
 

//搜索用
#pragma mark - 初始化视图
- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
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
    
    
    _dataArray=@[].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
}
#pragma mark - 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getNetworkData:searchBar.text page:page];
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
    
    _dataArray=@[].mutableCopy;
    [self getNetworkData:@"" page:page];
}



#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 60.0f;
    }
    return _tableView;
}
#pragma mark - UITableView delegate
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray count];
    
}
  

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScanRegisterModel *model=_dataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"ScanRegisterCell%@",model.id];
    ScanRegisterCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell==nil) {
        cell=[[ScanRegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
    [cell initViewWith:model];
   
    cell.delegate=self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(NSString *)keyword page:(int)page{
    
    _dataArray=@[].mutableCopy;
     
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:keyword forKey:@"keyword"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"]; 
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentRegistList"];
      
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            if([resultArray count]>0){
                for (NSDictionary *item in resultArray) {
                    ScanRegisterModel *model=[[ScanRegisterModel alloc] initWithDic:item];
                    [self->_dataArray addObject:model];
                }
                
                
                
            }
//            else{
//                NSDictionary *temp=@{@"id":@"3",@"xs_sex": @"男",@"xs_name": @"姓名_111111",@"class_name":@"12319239班",@"status": @"0" };
//
//                NSDictionary *temp1=@{@"id":@"4",@"xs_sex": @"女",@"xs_name": @"姓名_22222",@"class_name":@"12319239班",@"status": @"1" };
//                NSDictionary *temp2=@{@"id":@"5",@"xs_sex": @"男",@"xs_name": @"姓名_33333",@"class_name":@"12319239班",@"status": @"2" };
//                ScanRegisterModel *model=[[ScanRegisterModel alloc] initWithDic:temp];
//                [self->_dataArray addObject:model];
//                model=[[ScanRegisterModel alloc] initWithDic:temp1];
//                [self->_dataArray addObject:model];
//                model=[[ScanRegisterModel alloc] initWithDic:temp2];
//                [self->_dataArray addObject:model];
//            }
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


 - (void)delayMethod {
     [self.tableView reloadData];
     [self.tableView.mj_header endRefreshing];
     [self.tableView.mj_footer endRefreshing];
     
 }


#pragma mark - 同意拒绝
-(void)agreenRejectRecord:(NSString *)detailId state:(NSString *) state{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *postUrl=@"";
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
     
    if([state isEqualToString:@"1"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"agreeStudentRegistRecord"];
        if(![detailId isEqualToString:@"-1"]){
            [paramDic setObject:detailId forKey:@"sq_ids"];
        }
    }
    else{
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"rejectStudentRegistRecord"];
        [paramDic setObject:detailId forKey:@"sq_id"];
    }
      
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshSignIn" object:nil userInfo:nil]];
            [self getNetworkData:self.searchBar.text page:self->page];
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

- (void)clickStateBtn:(UIButton *)btn model:(ScanRegisterModel *)scanModel state:(NSString *)state {
    [self agreenRejectRecord:scanModel.id state:state];
}
 

@end
