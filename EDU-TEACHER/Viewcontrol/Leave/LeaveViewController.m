//
//  LeaveViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/3.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveViewController.h"
#import "DEFINE.h"
#import "LTSearchBar.h"
#import "GKWBPageViewController.h"
#import "GKPageScrollView.h"
#import "LeaveTableViewController.h"
#import "LeaveListCell.h"
#import "LeaveListModel.h"
#import "LeaveDetailViewController.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
@interface LeaveViewController ()<UISearchBarDelegate,GKPageScrollViewDelegate, WMPageControllerDataSource, WMPageControllerDelegate, GKWBPageViewControllDelegate,UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;

@property (nonatomic, strong) GKPageScrollView *pageScrollView;
@property (nonatomic, strong) GKWBPageViewController *pageVC;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVCs;

//搜索
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@end

@implementation LeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit=NO;
    [self initNavBar];
    [self initView];
    
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    //self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_tianjia"  target:self action:@selector(rightBarClick)];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"请假管理";
    self.gk_navTitleColor=[UIColor whiteColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick {
    
}
- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageScrollView reloadData];
    [_pageScrollView addSubview:self.addSearchBar];
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
    [_tableView removeFromSuperview];
    
}



#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.childVCs.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.childVCs[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 50, kWidth, 40.0f);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat maxY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:pageController.menuView]);
    return CGRectMake(0, maxY, kWidth, kHeight - maxY - kNavBarHeight);
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kNavBarHeight)];
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}
#pragma mark - 监听滚动
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    //禁止上下滑动
    scrollView.contentSize =  CGSizeMake(self.view.frame.size.width, 0);
}
#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
     
}

#pragma mark - GKWBPageViewControllDelegate
- (void)pageScrollViewWillBeginScroll {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)pageScrollViewDidEndedScroll {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        
        _pageScrollView.mainTableView.backgroundColor = GKColorGray(232);
    }
    return _pageScrollView;
}


- (GKWBPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[GKWBPageViewController alloc] init];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        _pageVC.scrollDelegate = self;
        
        // 菜单属性
        _pageVC.menuItemWidth = 80.0f;
        _pageVC.menuViewStyle = WMMenuViewStyleLine;
        _pageVC.menuViewLayoutMode=WMMenuViewLayoutModeLeft;
        
        _pageVC.titleSizeNormal     = 16.0f;
        _pageVC.titleSizeSelected   = 16.0f;
        _pageVC.titleColorNormal    = [UIColor blackColor];
        _pageVC.titleColorSelected  = GKColorHEX(0x2c92f5, 1);
        
        // 进度条属性
        _pageVC.progressColor               = GKColorHEX(0x2c92f5, 1);
        _pageVC.progressWidth               = 50.0f;
        _pageVC.progressHeight              = 3.0f;
        _pageVC.progressViewBottomSpace     = 0.0f; 
        //_pageVC.progressViewCornerRadius    = _pageVC.progressHeight / 2;
        
        // 调皮效果
        _pageVC.progressViewIsNaughty       = YES;
        //默认
        _pageVC.selectIndex=self.selectIndex;
    }
    return _pageVC;
}

- (UIView *)pageView {
    if (!_pageView) {
        [self addChildViewController:self.pageVC];
        [self.pageVC didMoveToParentViewController:self];
        
        _pageView = self.pageVC.view;
    }
    return _pageView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"待审批", @"已审批", @"待销假"];
    }
    return _titles;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        LeaveTableViewController *dspVC = [LeaveTableViewController new];
        dspVC.status=@"待审批";
        LeaveTableViewController *yspVC = [LeaveTableViewController new];
        yspVC.status=@"已审批";
        LeaveTableViewController *dxjVC = [LeaveTableViewController new];
        dxjVC.status=@"待销假";
        _childVCs = @[dspVC, yspVC, dxjVC];
    }
    return _childVCs;
}


//搜索用
#pragma mark - 初始化搜索视图
- (void)initSearchView{

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
        
         _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, kNavBarHeight+50, kWidth, kHeight-kNavBarHeight-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 90.0f;
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
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 70, 3)];
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
    static NSString *cellIde=@"leaveListCell";
    LeaveListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[LeaveListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *modelDic=_dataArray[indexPath.section][indexPath.row];
    LeaveListModel *model=[[LeaveListModel alloc] initWithDic:modelDic];
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
    [cell.statusLabel setHidden:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeaveDetailViewController *detailVC= [[LeaveDetailViewController alloc] init];
    NSDictionary *modelDic=_dataArray[indexPath.section][indexPath.row];
    detailVC.detailId=[modelDic objectForKey:@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(NSString *)keyword{
 
    _dataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"],@"keyword":keyword};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"searchLeaveList"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            resultDic=[resultDic objectForKey:@"Result"];
            if([resultDic count]>0){
                NSArray *keysArray = [resultDic allKeys];
                for (int i = 0; i < keysArray.count; i++) {
                    NSString *key = keysArray[i];
                    NSArray *value = resultDic[key];
                    [self->_sectionArray addObject:[NSString stringWithFormat:@"%@(%lu)",key,(unsigned long)[value count]]];
                    [self->_dataArray addObject:value];
                }
                
            }
            else{
                
            }
            [self initSearchView];
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
