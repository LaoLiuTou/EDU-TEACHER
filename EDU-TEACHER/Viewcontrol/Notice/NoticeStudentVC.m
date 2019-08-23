//
//  NoticeStudentVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/12.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "NoticeStudentVC.h"
#import "DEFINE.h"
#import "MJRefresh.h"
#import "GKWBListViewController.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "NoticeStuCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "NoticeModel.h"
@interface NoticeStudentVC ()<UITableViewDataSource, UITableViewDelegate,NoticeStuCellDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation NoticeStudentVC

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
    
    NoticeStuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[NoticeStuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[cellDic objectForKey:@"xs_image"]];
    
    
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
    cell.nameLabel.text=[cellDic objectForKey:@"xs_name"];
    if([_type isEqualToString:@"已读"]){
        [cell.statusBtn setHidden:YES];
    }
    else{
        [cell.statusBtn setHidden:NO];
        
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
- (void)clickNoticeBtn:(UIButton *)btn stuDic:(NSDictionary *)stu {
    NSLog(@"%@,%@",stu ,self.noticeId);
    [self noticeUnread:stu noticeId:self.noticeId];
    
}

#pragma mark - 通知未读
-(void)noticeUnread:(NSDictionary *)stu noticeId:(NSString *)noticeId{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"id":noticeId,@"xs_id":[stu objectForKey:@"xs_id"]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"warnXsSeeTongzhi"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            
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
