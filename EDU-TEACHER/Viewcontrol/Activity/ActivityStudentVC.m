//
//  ActivityStudentVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ActivityStudentVC.h"
#import "DEFINE.h"
#import "MJRefresh.h"
#import "GKWBListViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "ActivityStuCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "ActivityModel.h"
@interface ActivityStudentVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation ActivityStudentVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initNavBar];
    
}


#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navigationBar.hidden = YES;
}
#pragma mark - 初始化视图
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 50.0f;
    }
    return _tableView;
}


#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellDic=_listDataArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",[cellDic objectForKey:@"id"]];
    
    ActivityStuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ActivityStuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[cellDic objectForKey:@"xs_image"]];
    
    
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
    cell.nameLabel.text=[cellDic objectForKey:@"xs_name"]; 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewDidScroll = callback;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewDidScroll ? : self.listScrollViewDidScroll(scrollView);
}
 


@end
