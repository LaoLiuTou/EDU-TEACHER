//
//  NoteVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoteVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "NoteModel.h"
#import "NoteCell.h"
#import "AddNoteVC.h"
#import "NoteDetailVC.h"
#import "LTSearchBar.h"
#import "YBPopupMenu.h"
#import "AddNoteVC.h"
#import "AddMemoVC.h"
#import "NoteDetailVC.h"
#import "YTTextViewAlertView.h"
@interface NoteVC ()<UITableViewDataSource, UITableViewDelegate,NoteCellDelegate,UISearchBarDelegate,YBPopupMenuDelegate>
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@end

@implementation NoteVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit=NO;
    [self initNavBar];
    [self initView];
    [self.view addSubview:self.addSearchBar];
    [self getNetworkData:@""];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick:)];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"我的日志";
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
    //[self.navigationController pushViewController:[SelectStudentVC new] animated:YES];
    [YBPopupMenu showRelyOnView:sender titles:@[ @"工作备忘",@"工作日志"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth = 0;
        popupMenu.delegate = self;
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = NO;
        //popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        popupMenu.type = YBPopupMenuTypeDefault;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",@[@"工作日志", @"工作备忘"][index]);
    switch (index) {
        case 0:
           [self.navigationController pushViewController:[AddMemoVC new] animated:YES];
            break;
        case 1:
            
             [self.navigationController pushViewController:[AddNoteVC new] animated:YES];
            break;
        
        default:
            break;
    }
    
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
    _sectionArray=@[].mutableCopy;
    [self.tableView reloadData];
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
    [self getNetworkData:@""];
}



#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 70.0f;
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
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 37, 60, 3)];
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
    NoteModel *model=_dataArray[indexPath.section][indexPath.row];
    NSString *sectionType=_sectionArray[indexPath.section];
    NSString *cellIde=[NSString stringWithFormat:@"NoteCell%@%@",sectionType,model.id];
    NoteCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell==nil) {
        cell=[[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
    [cell initViewWith:model sectionType:sectionType];
    if([sectionType isEqualToString:@"工作备忘"]){
        [cell.statusBtn setHidden:NO]; 
        [cell.leftview setHidden:NO];
    }
    else{
        [cell.statusBtn setHidden:YES];
        [cell.leftview setHidden:YES]; 
    }
   
    cell.delegate=self;
    cell.note=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *model=_dataArray[indexPath.section][indexPath.row];
    NSString *sectionType=_sectionArray[indexPath.section];
    NoteDetailVC *jumpVC= [NoteDetailVC new];
    jumpVC.noteType=sectionType;
    jumpVC.detailId=model.id;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(NSString *)keyword{
    
    _dataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:keyword forKey:@"keyword"];
    
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryRizhiList"];
    
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            resultDic=[resultDic objectForKey:@"Result"];
            if([resultDic count]>0){
                
                NSArray *beiwangArray=[resultDic objectForKey:@"beiwang"];
                [self->_sectionArray addObject:[NSString stringWithFormat:@"%@",@"工作备忘"]];
                NSMutableArray *temp=[NSMutableArray new];
                for (NSDictionary *item in beiwangArray) {
                    NoteModel *model=[[NoteModel alloc] initWithDic:item];
                    [temp addObject:model];
                }
                [self->_dataArray addObject:temp];
                 
                
                NSArray *rizhiArray=[resultDic objectForKey:@"rizhi"];
                [self->_sectionArray addObject:[NSString stringWithFormat:@"%@",@"工作日志"]];
                temp=[NSMutableArray new];
                for (NSDictionary *item in rizhiArray) {
                    NoteModel *model=[[NoteModel alloc] initWithDic:item];
                    [temp addObject:model];
                }
                [self->_dataArray addObject:temp];
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

-(void)clickFinishBtn:(UIButton *)btn note:(NoteModel *) note{
    NSLog(@"%@",note);
    YTTextViewAlertView *alertView = [YTTextViewAlertView new];
    [alertView show];
    
    alertView.ytAlertViewMakeSureBlock = ^(NSString *repulse_evaluate_str) {
        
        [self finishNoteByDetailId:note.id comment:repulse_evaluate_str];
    };
    
    alertView.ytAlertViewCloseBlock = ^{
        
    };
}

#pragma mark - 补签
-(void)finishNoteByDetailId:(NSString *)detailId comment:(NSString *) comment{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:detailId forKey:@"id"];
    [paramDic setObject:comment forKey:@"finish_comment"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"finishBeiwang"];
    
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
