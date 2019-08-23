//
//  StudentInfoVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentInfoVC.h"
#import "DEFINE.h"
#import "StudentInfoView.h"
@interface StudentInfoVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) StudentInfoView *studentView ;
@end

@implementation StudentInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavBar];
    [self initView];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"基础信息";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    StudentInfoView *studentView = [[StudentInfoView alloc]init];
    self.studentView=studentView;
    //self.studentView.frame = CGRectMake(0, 0, kWidth, kHeight);
    int y=[self.studentView initViewModel:self.studentModel];
    [self.scrollView addSubview:self.studentView];
    _scrollView.contentSize =CGSizeMake(0,y+10);
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _scrollView.backgroundColor=[UIColor whiteColor];
        
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}

@end
