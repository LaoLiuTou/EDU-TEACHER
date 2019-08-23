//
//  ClassSignInDetailVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ClassSignInDetailVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "GKWBPageViewController.h"
#import "GKPageScrollView.h"
#import "ClassSignInDetailView.h"
#import "ClassSignInModel.h"
#import "SignInStudentVC.h"
#import "LTSearchBar.h"
#import "SearchSignInStudentVC.h"
@interface ClassSignInDetailVC ()<GKPageScrollViewDelegate, WMPageControllerDataSource, WMPageControllerDelegate, GKWBPageViewControllDelegate,UISearchBarDelegate>
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
@property (nonatomic, strong) GKWBPageViewController *pageVC;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) ClassSignInModel *model;

@property (nonatomic, strong) LTSearchBar *searchBar;
@end

@implementation ClassSignInDetailVC{
    int viewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSignIn:) name:@"refreshSignIn" object:nil];
    [self initNavBar];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self getNetworkData:@"0"];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"课程签到";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.pageScrollView];
    [self.view sendSubviewToBack:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageScrollView reloadData];
}


#pragma mark - 添加搜索条
- (LTSearchBar *)addSearchBar {
    //加上 搜索栏
    self.searchBar= [[LTSearchBar alloc] initWithFrame:CGRectMake(10,5, kWidth-20 , 40)];
    self.searchBar.isChangeFrame=NO;
    self.searchBar.showCancel=NO;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    //输入框提示
    self.searchBar.placeholder = @"搜索";
    //光标颜色
    self.searchBar.cursorColor = [UIColor clearColor];
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
    return self.searchBar;
}
#pragma mark - 已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    SearchSignInStudentVC *jumpVC=[SearchSignInStudentVC new];
    jumpVC.type=@"课程签到";
    jumpVC.detailId=self.detailId;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark - 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}
#pragma mark - 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}
#pragma mark - 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}





- (void)refreshSignIn:(NSNotification *)notification{
    _titles=@[];
    _childVCs=@[];
    [self getNetworkData:@"1"];
    
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
    return CGRectMake(0, 0, kWidth, 40.0f);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat maxY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:pageController.menuView]);
    return CGRectMake(0, maxY, kWidth, kHeight - maxY -kNavBarHeight);
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    //return [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWidth, 200)];
    //view初始化
    
    ClassSignInDetailView *classSignInDetailView = [[ClassSignInDetailView alloc] init];
    viewHeight=[classSignInDetailView initModel:self.model];
    classSignInDetailView.frame=CGRectMake(0, 50, kWidth, viewHeight);
    
    UIView *detailView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, viewHeight+50)];
    _detailView=detailView;
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kWidth, 50)];
    searchView.backgroundColor=[UIColor whiteColor];
    [searchView addSubview:self.addSearchBar];
    
    [_detailView addSubview:classSignInDetailView];
    [_detailView addSubview:searchView];
    
    return _detailView;
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
    //scrollView.contentSize =  CGSizeMake(self.view.frame.size.width, 0);
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
        _pageVC.menuItemWidth = 100.0f;
        _pageVC.menuViewStyle = WMMenuViewStyleLine;
        _pageVC.menuViewLayoutMode=WMMenuViewLayoutModeLeft;
        
        _pageVC.titleSizeNormal     = 16.0f;
        _pageVC.titleSizeSelected   = 16.0f;
        _pageVC.titleColorNormal    = [UIColor blackColor];
        _pageVC.titleColorSelected  = GKColorHEX(0x2c92f5, 1);
        
        // 进度条属性
        _pageVC.progressColor               = GKColorHEX(0x2c92f5, 1);
        _pageVC.progressWidth               = 80.0f;
        _pageVC.progressHeight              = 3.0f;
        _pageVC.progressViewBottomSpace     = 0.0f;
        //_pageVC.progressViewCornerRadius    = _pageVC.progressHeight / 2;
        
        // 调皮效果
        _pageVC.progressViewIsNaughty       = YES;
        //默认
        
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
        _titles = @[[NSString stringWithFormat:@"已签到 %@",self.model.sign_count],
                    [NSString stringWithFormat:@"未签到 %@",self.model.unsign_count]];
    //}
    return _titles;
}

- (NSArray *)childVCs {
    //if (!_childVCs) {
        SignInStudentVC *listVC1 = [SignInStudentVC new];
        listVC1.signType=@"已签到";
        listVC1.type=@"课程签到";
        listVC1.detailId=self.detailId;
        listVC1.listDataArray=self.model.sign_list;
        SignInStudentVC *listVC2 = [SignInStudentVC new];
        listVC2.listDataArray=self.model.unsign_list;
        listVC2.signType=@"未签到";
        listVC2.type=@"课程签到";
        listVC2.detailId=self.detailId;
        _childVCs = @[listVC1, listVC2];
    //}
    return _childVCs;
}


#pragma mark - 网络请求获取数据
-(void)getNetworkData:(NSString *) refresh{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryKqSignDetail"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            ClassSignInModel *model=[[ClassSignInModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.model=model;
            //[self.pageScrollView refreshHeaderView];
            if([refresh isEqualToString:@"1"]){
                [self.pageScrollView reloadData];
                [self.pageVC reloadData];
            }
            [self initView];
            
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
