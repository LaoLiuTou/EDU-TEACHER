//
//  NoteDetailVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoteDetailVC.h"

#import "DEFINE.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "GKWBPageViewController.h"
#import "GKPageScrollView.h"
#import "NoteDetailView.h"
#import "NoteModel.h"
#import "NoticeStudentVC.h"
@interface NoteDetailVC ()<GKPageScrollViewDelegate, WMPageControllerDataSource, WMPageControllerDelegate, GKWBPageViewControllDelegate>
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
@property (nonatomic, strong) GKWBPageViewController *pageVC;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) NoteDetailView *detailView;
@property (nonatomic, strong) NoteModel *noteModel;
@end

@implementation NoteDetailVC{
    int viewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavBar];
    [self getNetworkData];
    
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    
    if([self.noteType isEqualToString:@"工作日志"]){
        self.gk_navTitle=@"查看日志";
    }
    else{
        self.gk_navTitle=@"查看备忘录";
    }
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
- (void)noticeReadList{
    [self getNetworkData];
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
    NoteDetailView *detailView = [[NoteDetailView alloc] init];
    _detailView=detailView;
    viewHeight=[_detailView initModel:self.noteModel type:self.noteType];
    _detailView.frame=CGRectMake(0, 0, kWidth, viewHeight);
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
        _pageVC.menuItemWidth = 80.0f;
        _pageVC.menuViewStyle = WMMenuViewStyleLine;
        _pageVC.menuViewLayoutMode=WMMenuViewLayoutModeLeft;
        
        _pageVC.titleSizeNormal     = 16.0f;
        _pageVC.titleSizeSelected   = 16.0f;
        _pageVC.titleColorNormal    = [UIColor blackColor];
        _pageVC.titleColorSelected  = GKColorHEX(0x2c92f5, 1);
        
        // 进度条属性
        _pageVC.progressColor               = GKColorHEX(0x2c92f5, 1);
        _pageVC.progressWidth               = 64.0f;
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
    if (!_titles) {
        _titles = @[@"相关学生"];
    }
    return _titles;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        NoticeStudentVC *listVC1 = [NoticeStudentVC new];
        listVC1.type=@"已读";
        listVC1.noticeId=self.detailId;
        listVC1.listDataArray=self.noteModel.xs_list;
        
        _childVCs = @[listVC1];
    }
    return _childVCs;
}


#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=@"";
    
    if([self.noteType isEqualToString:@"工作日志"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryRizhiDetail"];
    }
    else{
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryBeiwangDetail"];
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NoteModel *model=[[NoteModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.noteModel=model;
            //[self.pageScrollView refreshHeaderView];
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

