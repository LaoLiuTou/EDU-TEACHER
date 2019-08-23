//
//  SearchSignInStudentVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SearchSignInStudentVC.h"
#import "DEFINE.h"
#import "LTSearchBar.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "SignInStudentCell.h"
#import "UIImageView+WebCache.h"
#import "OtherSignInDetailVC.h"
#import "ClassSignInDetailVC.h"
#import "DormSignInDetailVC.h"
#import "ActivitySignInDetailVC.h"
@interface SearchSignInStudentVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,SignInStudentDelegate>
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@end

@implementation SearchSignInStudentVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit=NO;
    [self initNavBar];
    [self initSearchView];
    [self.view addSubview:self.addSearchBar];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    //self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_tianjia"  target:self action:@selector(rightBarClick)];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=self.type;
    self.gk_navTitleColor=[UIColor whiteColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索用
#pragma mark - 初始化搜索视图
- (void)initSearchView{
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
    
    [self.searchBar becomeFirstResponder];
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
    _dataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 50.0f;
    }
    return _tableView;
}
#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];//创建一个视图
    headerView.backgroundColor= [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kWidth-30, 37)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    headerLabel.textColor = GKColorHEX(0x2c92f5,1);
    headerLabel.text = [NSString stringWithFormat:@"%@",_sectionArray[section]];
    [headerView addSubview:headerLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 50, 3)];
    bottomLabel.backgroundColor = GKColorHEX(0x2c92f5,1);
    [headerView addSubview:bottomLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellDic=_dataArray[indexPath.section][indexPath.row];
    NSString *sectionType=_sectionArray[indexPath.section];
    NSString *cellIde=[NSString stringWithFormat:@"searchStudentCell%@",[cellDic objectForKey:@"id"]];
    SignInStudentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell==nil) {
        cell=[[SignInStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[cellDic objectForKey:@"xs_image"]];
    
     
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
    cell.nameLabel.text=[cellDic objectForKey:@"xs_name"];
    if([sectionType isEqualToString:@"已签到"]){
        [cell.statusBtn setHidden:YES];
    }
    else{
        [cell.statusBtn setHidden:NO];
        
    }
    if([[cellDic objectForKey:@"is_leave"] isEqualToString:@"false"]){
       [cell.leaveLabel setHidden:YES];
    }
    cell.stuDic=cellDic;
    cell.delegate=self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(NSString *)keyword{
    
    _dataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":self.detailId,@"keyword":keyword};
    
    NSString *postUrl=@"";
    if([self.type isEqualToString:@"其他签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"searchJqSignStudent"];
    }
    else if([self.type isEqualToString:@"宿舍签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"searchSsqSignStudent"];
    }
    else if([self.type isEqualToString:@"课程签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"searchKqSignStudent"];
    }
    else if([self.type isEqualToString:@"活动签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"searchHqSignStudent"];
    }
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            resultDic=[resultDic objectForKey:@"Result"];
            if([resultDic count]>0){
                
                NSArray *signArray=[resultDic objectForKey:@"sign_list"];
                if(signArray.count>0){
                    //[self->_sectionArray addObject:[NSString stringWithFormat:@"%@(%@)",@"已签到",[resultDic objectForKey:@"sign_count"]]];
                    [self->_sectionArray addObject:[NSString stringWithFormat:@"%@",@"已签到"]];
                    [self->_dataArray addObject:[resultDic objectForKey:@"sign_list"]];
                }
                NSArray *unsignArray=[resultDic objectForKey:@"unsign_list"];
                if(unsignArray.count>0){
                    //[self->_sectionArray addObject:[NSString stringWithFormat:@"%@(%@)",@"未签到",[resultDic objectForKey:@"unsign_count"]]];
                    [self->_sectionArray addObject:[NSString stringWithFormat:@"%@",@"未签到"]];
                    [self->_dataArray addObject:[resultDic objectForKey:@"unsign_list"]];
                }
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

- (void)clickSignInBtn:(UIButton *)btn stuDic:(NSDictionary *)stu {
    NSLog(@"%@,%@",stu ,self.detailId);
    [self reSignIn:stu detailId:self.detailId];
    
}

#pragma mark - 补签
-(void)reSignIn:(NSDictionary *)stu detailId:(NSString *)detailId{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":[stu objectForKey:@"id"]};
    NSString *postUrl=@"";
    if([self.type isEqualToString:@"其他签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supJqSign"];
    }
    else if([self.type isEqualToString:@"宿舍签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supSsqSign"];
    }
    else if([self.type isEqualToString:@"课程签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supKqSign"];
    }
    else if([self.type isEqualToString:@"活动签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supHqSign"];
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshSignIn" object:nil userInfo:nil]];
            [self getNetworkData:self.searchBar.text];
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
