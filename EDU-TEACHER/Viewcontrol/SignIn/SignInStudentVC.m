//
//  SignInStudentVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SignInStudentVC.h"
#import "DEFINE.h"
#import "MJRefresh.h"
#import "GKWBListViewController.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SignInStudentCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "OtherSignInDetailVC.h"
@interface SignInStudentVC ()<UITableViewDataSource, UITableViewDelegate,SignInStudentDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation SignInStudentVC

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
    
    SignInStudentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[SignInStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[cellDic objectForKey:@"xs_image"]];
    
   
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
    cell.nameLabel.text=[cellDic objectForKey:@"xs_name"];
    if([_signType isEqualToString:@"已签到"]){
        [cell.statusBtn setHidden:YES];
    }
    else{
        [cell.statusBtn setHidden:NO];
        
    }
    if([[cellDic objectForKey:@"is_leave"] isEqualToString:@"true"]){
        [cell.leaveLabel setHidden:NO];
    }
    cell.stuDic=cellDic;
    cell.delegate=self;
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
    NSString *notiString = @"";
    if([self.type isEqualToString:@"其他签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supJqSign"];
        notiString=@"refreshOtherSignInListItem";
    }
    else if([self.type isEqualToString:@"宿舍签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supSsqSign"];
        notiString=@"refreshDormSignInListItem";
    }
    else if([self.type isEqualToString:@"课程签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supKqSign"];
        notiString=@"refreshClassSignInListItem";
    }
    else if([self.type isEqualToString:@"活动签到"]){
        postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"supHqSign"];
        notiString=@"refreshActivitySignInListItem";
    }
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshSignIn" object:nil userInfo:nil]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notiString object:nil userInfo:nil]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshSearchSignInListItem" object:nil userInfo:nil]]; 
            
            
            
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
