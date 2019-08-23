//
//  SelectClassVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectClassVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "SelectClassCell.h"
#import "ClassModel.h"
@interface SelectClassVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@end
 
@implementation SelectClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    
    [self getNetworkData];
    _listDataArray=@[].mutableCopy;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"选择课程";
    self.gk_navTitleColor=[UIColor blackColor];
}


- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
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
    ClassModel *model=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    
    SelectClassCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[SelectClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell initViewWithModel:model];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassModel *model=_listDataArray[indexPath.row];
    NSMutableDictionary *temp = [NSMutableDictionary new];
    [temp setObject:model.id forKey:@"class_id" ];
    [temp setObject:model.lesson_name forKey:@"class_name" ];
    [temp setObject:model.room==nil?@"":model.room forKey:@"room" ];
    [temp setObject:model.teacher forKey:@"teacher" ];
    
    //NSArray *tempArray=@[@{@"ST_CLASS_ORDER":@"1",@"ED_CLASS_ORDER":@"2",@"WEEKS":@"1,3,5,7,9,11",@"WEEKDAYS":@"3,4"}];
  
     [temp setObject:model.timetable_info forKey:@"timetable" ];
    
    [temp setObject:model.xs_info forKey:@"xs_info" ];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectClass" object:nil userInfo:[temp copy]]];
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryLessonList"];
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"]};
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *resultArray=[resultDic objectForKey:@"Result"];
            for (NSDictionary *item in resultArray) {
                
                ClassModel *model=[[ClassModel alloc] initWithDic:item];
                [self.listDataArray addObject:model];
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

