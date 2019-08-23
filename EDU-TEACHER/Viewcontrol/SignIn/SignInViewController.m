//
//  LeaveViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/3.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SignInViewController.h"
#import "DEFINE.h"
#import "LTSearchBar.h"
#import "GKWBPageViewController.h"
#import "GKPageScrollView.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "SelectStudentVC.h"
#import "SelectStudentTVC.h"
#import "SignInTableViewController.h"
#import "SignInListCell.h"
#import "SignInModel.h"
#import "YBPopupMenu.h"
#import "MJRefresh.h"
#import "AddActivitySignInVC.h"
#import "AddClassSignInVC.h"
#import "AddDormSignInVC.h"
#import "AddOtherSignInVC.h"
#import "OtherSignInDetailVC.h"
#import "ClassSignInDetailVC.h"
#import "DormSignInDetailVC.h"
#import "ActivitySignInDetailVC.h"
@interface SignInViewController ()<UISearchBarDelegate,GKPageScrollViewDelegate, WMPageControllerDataSource, WMPageControllerDelegate, GKWBPageViewControllDelegate,UITableViewDataSource, UITableViewDelegate,SignInCellDelegate,YBPopupMenuDelegate>
@property(nonatomic,assign)BOOL isEdit;
@property (nonatomic, strong) LTSearchBar *searchBar;

@property (nonatomic, strong) GKPageScrollView *pageScrollView;
@property (nonatomic, strong) GKWBPageViewController *pageVC;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVCs;

//搜索
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listDataArray;
@property (nonatomic, strong) NSIndexPath   *selectSearchIndex;//点击的cell  刷新用
@end

@implementation SignInViewController{
    int page;
}


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
    self.gk_navRightBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:[self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(24, 24)] target:self action:@selector(rightBarClick:)];
     
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitle=@"签到管理";
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
    [YBPopupMenu showRelyOnView:sender titles:@[@"课程签到", @"宿舍签到", @"活动签到",@"其他签到"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
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
    NSLog(@"点击了 %@ 选项",@[@"课程签到", @"宿舍签到", @"活动签到",@"其他签到"][index]);
    switch (index) {
        case 0:
            [self.navigationController pushViewController:[AddClassSignInVC new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[AddDormSignInVC new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[AddActivitySignInVC new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[AddOtherSignInVC new] animated:YES];
            break;
        default:
            break;
    }
    
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
    [self initSearchView];
  
    searchBar.showsCancelButton = YES;
    [self.view endEditing:YES];
    //收起键盘后取消无效
    self.searchBar.cancleButton.enabled=YES;
    
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSearchSignInListItem:) name:@"refreshSearchSignInListItem" object:nil];
    
    //刷新加载
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page=1;
        self->_listDataArray=@[].mutableCopy;
        [weakSelf getNetworkData:self->page keyword:searchBar.text];
    }];
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [weakSelf getNetworkData:self->page keyword:searchBar.text];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
}
#pragma mark - 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    _isEdit=NO;
    [_tableView removeFromSuperview];
     [self.pageVC reloadData];
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
        
        _pageVC.menuItemWidth = kWidth / 5.0f ;
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
    //if (!_titles) {
        _titles = @[@"全部", @"课程", @"宿舍",@"活动",@"其他"];
    //}
    return _titles;
}

- (NSArray *)childVCs {
    //if (!_childVCs) {
        SignInTableViewController *signinTVC1 = [SignInTableViewController new];
        signinTVC1.type=@"全部";
        SignInTableViewController *signinTVC2 = [SignInTableViewController new];
        signinTVC2.type=@"课程";
        SignInTableViewController *signinTVC3 = [SignInTableViewController new];
        signinTVC3.type=@"宿舍";
        SignInTableViewController *signinTVC4 = [SignInTableViewController new];
        signinTVC4.type=@"活动";
        SignInTableViewController *signinTVC5 = [SignInTableViewController new];
        signinTVC5.type=@"其他";
        _childVCs = @[signinTVC1, signinTVC2, signinTVC3,signinTVC4,signinTVC5];
    //}
    return _childVCs;
}


//搜索用
#pragma mark - 初始化搜索视图
- (void)initSearchView{
    
    [self.view addSubview:self.tableView];
    self->_listDataArray=@[].mutableCopy;
    [self.tableView reloadData];  
     
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
    
}
#pragma mark - 刷新cell 签到数
- (void)refreshSearchSignInListItem:(NSNotification *)notification{
//    SignInModel *model=_listDataArray[self.selectSearchIndex.row];
//    int count=[model.signed_count intValue];
//    model.signed_count=[NSString stringWithFormat:@"%d",(count+1)];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectSearchIndex,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView.mj_header beginRefreshing];
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
    if([model.type isEqualToString:@"课程签到"]){
        [cell.typeLabel setText:@"课程"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(120 , 180 , 50)];
    }
    else if([model.type isEqualToString:@"宿舍签到"]){
        [cell.typeLabel setText:@"宿舍"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(241 , 168 , 0)];
    }
    else if([model.type isEqualToString:@"活动签到"]){
        [cell.typeLabel setText:@"活动"];
        [cell.typeLabel setBackgroundColor:GKColorRGB(234 , 58 , 50)];
    }
    else if([model.type isEqualToString:@"其他签到"]){
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
    self.selectSearchIndex=indexPath;
    if([model.type isEqualToString:@"课程签到"]){
        ClassSignInDetailVC *jumpVC=[ClassSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"宿舍签到"]){
        DormSignInDetailVC *jumpVC=[DormSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"活动签到"]){
        ActivitySignInDetailVC *jumpVC=[ActivitySignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if([model.type isEqualToString:@"其他签到"]){
        OtherSignInDetailVC *jumpVC=[OtherSignInDetailVC new];
        jumpVC.detailId=model.id;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData:(int)page keyword:(NSString *) keyword{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [paramDic setObject:keyword forKey:@"keyword"];
    NSString * postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryAllSignList"];
    
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

- (void)delayMethod {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    
    if([model.type isEqualToString:@"课程签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishKqSign"];
    }
    else if([model.type isEqualToString:@"宿舍签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishSsqSign"];
    }
    else if([model.type isEqualToString:@"活动签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishHqSign"];
    }
    else if([model.type isEqualToString:@"其他签到"]){
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
    
    if([model.type isEqualToString:@"课程签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"finishKqSign"];
    }
    else if([model.type isEqualToString:@"宿舍签到"]){
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


@end
