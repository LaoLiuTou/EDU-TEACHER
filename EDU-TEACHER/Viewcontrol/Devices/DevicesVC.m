//
//  DevicesVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/29.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "DevicesVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "GKWBListViewController.h"
#import "DevicesCell.h"
@interface DevicesVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableDictionary  *selectDic; 
@end


@implementation DevicesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavBar];
    [self getNetworkData];
}

#pragma mark - 初始化搜索视图
- (void)initView{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectBtn];
    
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"选择签到设备";
    self.gk_navTitleColor=[UIColor whiteColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0,kNavBarHeight, kWidth, kHeight-kNavBarHeight-BottomPaddingHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 40.0f;
    }
    return _tableView;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, kHeight-50-BottomPaddingHeight, kWidth-40*2, 40)];
        _selectBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setTitle:@"完成" forState:UIControlStateNormal];
        _selectBtn.layer.cornerRadius=16;
        _selectBtn.layer.masksToBounds=YES;
        _selectBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _selectBtn;
}
#pragma mark - UITableView delegate


//完成
- (void)clickSelectBtn:(UIButton *)sender{
    _selectDic=@{}.mutableCopy;
    NSMutableArray *titleArray=[NSMutableArray new];
    NSMutableArray *titleIdArray=[NSMutableArray new];
    
    for(NSDictionary *tempDic in _dataArray){
        if([[tempDic objectForKey:@"status"] isEqualToString:@"select"]){
            
            [titleArray addObject:[tempDic objectForKey:@"eq_name"]];
            [titleIdArray addObject:[tempDic objectForKey:@"id"]];
        }
    }
     
    [_selectDic setObject:titleArray forKey:@"title"];
    [_selectDic setObject:titleIdArray forKey:@"titleId"];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectDevices" object:nil userInfo:self.selectDic]];
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *tempDic=_dataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",[tempDic objectForKey:@"id"]];
    DevicesCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[DevicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text =[tempDic objectForKey:@"eq_name"];
    cell.status=[tempDic objectForKey:@"status"];
    if([cell.status isEqualToString:@"select"]){
        [cell chageStatus:@"select"];
    }
    else{
        [cell chageStatus:@"unselect"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DevicesCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *tempDic=[_dataArray[indexPath.row] mutableCopy];
    if([cell.status isEqualToString:@"select"]){
        cell.status=@"unselect";
        //[cell chageStatus:@"unselect"];
        [tempDic setObject:@"unselect" forKey:@"status"];
        
    }
    else{
        cell.status=@"select";
        //[cell chageStatus:@"selected"];
        [tempDic setObject:@"select" forKey:@"status"];
    }
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    
    _dataArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryFdEquipmentList"];
    
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            if([resultArray count]>0){
                for (NSDictionary *tempDic in resultArray) {
                    NSMutableDictionary *tempMutableDic=[tempDic mutableCopy];
                    
                    if([self.value containsObject:[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"id"]]]){
                        [tempMutableDic setObject:@"select" forKey:@"status"];
                    }
                    else{
                        [tempMutableDic setObject:@"unselect" forKey:@"status"];
                    }
                    
                    
                    [self->_dataArray addObject:tempMutableDic];
                }
                [self initView];
                
            }
            else{
                
            }
            
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
