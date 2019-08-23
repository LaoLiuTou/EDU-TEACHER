//
//  ResigninVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ResigninVC.h"
#import "DEFINE.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "GKWBListViewController.h"
#import "ResigninCell.h"
@interface ResigninVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableDictionary  *selectDic;
@end


@implementation ResigninVC


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
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0,kNavBarHeight, kWidth, kHeight-kNavBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 40.0f;
    }
    return _tableView;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, kHeight-50, kWidth-40*2, 40)];
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
    NSMutableArray *valueArray=[NSMutableArray new];
    for(NSDictionary *tempDic in _dataArray){
        if([[tempDic objectForKey:@"status"] isEqualToString:@"select"]){
            
            [titleArray addObject:[tempDic objectForKey:@"title"]];
            [valueArray addObject:[tempDic objectForKey:@"value"]];
            
        }
    }
    
    [_selectDic setObject:titleArray forKey:@"titles"];
    [_selectDic setObject:valueArray forKey:@"values"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectResignin" object:nil userInfo:self.selectDic]];
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *tempDic=_dataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",[tempDic objectForKey:@"id"]];
    ResigninCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ResigninCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text =[tempDic objectForKey:@"title"];
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
    ResigninCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
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
    NSArray *titleArray=@[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    NSArray *valueArray=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    _dataArray=@[].mutableCopy;
    for (int i=0;i<7;i++) {
        NSMutableDictionary *tempMutableDic=[NSMutableDictionary new];
        [tempMutableDic setObject:titleArray[i] forKey:@"title"];
        [tempMutableDic setObject:valueArray[i] forKey:@"value"];
        if([self.value containsObject:valueArray[i]]){
            [tempMutableDic setObject:@"select" forKey:@"status"];
        }
        else{
            [tempMutableDic setObject:@"unselect" forKey:@"status"];
        }
        [self->_dataArray addObject:tempMutableDic];
    }
    [self initView];
    
    
}


@end
