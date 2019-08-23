//
//  LeaveDetailViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/4.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LeaveDetailViewController.h"
#import "LeaveDetailView.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "LeaveDetailModel.h"
#import "LeaveViewController.h"
@interface LeaveDetailViewController ()
@property (nonatomic,strong) LeaveDetailView *detailView;
@property (nonatomic,strong) LeaveDetailModel *detailModel;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation LeaveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getNetworkData];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES; 
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"请假详细";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initView{
     [self.view addSubview:self.scrollView];
    
    //view初始化
    LeaveDetailView *detailView = [[LeaveDetailView alloc]init];
    _detailView=detailView;
    _detailView.frame = CGRectMake(0, 0, kWidth, kHeight);
    
    
    //不同状态显示不同信息
     [_detailView.statusLabel setText:_detailModel.status];
    if([_detailModel.status isEqualToString:@"已驳回"]||[_detailModel.status isEqualToString:@"已通过"]){
        if([_detailModel.status isEqualToString:@"已驳回"]){
            [_detailView.statusLabel setText:@"已拒绝"];
            if([_detailModel.is_leaveschool isEqualToString:@"是"]){
                _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"是否销假",@"审批人",@"审批时间"];
                [_detailView.statusLabel setTextColor:GKColorRGB(242 , 89 , 75)];
            }
            else if([_detailModel.is_leaveschool isEqualToString:@"否"]){
                _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"审批人",@"审批时间"];
                [_detailView.statusLabel setTextColor:GKColorRGB(242 , 89 , 75)];
                
            }
            
        }
        else if([_detailModel.status isEqualToString:@"已通过"]){
            if([_detailModel.is_xiaojia isEqualToString:@"是"]&&[_detailModel.is_leaveschool isEqualToString:@"是"]){
                [_detailView.statusLabel setText:@"已销假"];
                _detailView.statusLabel.textColor=[UIColor grayColor]; _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"是否销假",@"审批人",@"审批时间",@"销假时间"];
                
            }
            else if([_detailModel.is_xiaojia isEqualToString:@"否"]&&[_detailModel.is_leaveschool isEqualToString:@"是"]){
                [_detailView.statusLabel setTextColor:GKColorHEX(0x2c92f5, 1)];
                _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"是否销假",@"审批人",@"审批时间"];
                
                [self addBtnType:2];
            }
            else if([_detailModel.is_leaveschool isEqualToString:@"否"]){
                [_detailView.statusLabel setTextColor:GKColorHEX(0x2c92f5, 1)];
                _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"审批人",@"审批时间"];
                
                //[self addBtnType:2];
            }
            else{
                _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"是否销假",@"审批人",@"审批时间"];
                [_detailView.statusLabel setTextColor:GKColorHEX(0x2c92f5, 1)];
            }
       
        }
        
    }
    else if([_detailModel.status isEqualToString:@"待审批"]){
        _detailView.statusLabel.textColor=[UIColor grayColor];
        _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校"];
        [self addBtnType:1];
        
    }
//    else if([_detailModel.status isEqualToString:@"待销假"]){
//        _detailView.statusLabel.textColor=[UIColor grayColor];
//        _detailView.titleArray=@[@"开始时间",@"结束时间",@"请假时长",@"本月请假次数",@"是否离校",@"是否销假",@"审批人",@"审批时间"];
//
//        [self addBtnType:2];
//    }
    [_detailView initView];
    
    //头部赋值
    [_detailView.xs_nameLabel setText:_detailModel.xs_name];
    [_detailView.typeLabel setText:_detailModel.type];
    if([_detailModel.type isEqualToString:@"病假"]){
        [_detailView.typeLabel setBackgroundColor:GKColorRGB(129 , 184 , 79)];
    }
    else if([_detailModel.type isEqualToString:@"事假"]){
        [_detailView.typeLabel setBackgroundColor:GKColorRGB(241 , 173 , 50)];
    }
    
   
    [(UILabel *)[_detailView viewWithTag:1000] setText:_detailModel.start_time];
    [(UILabel *)[_detailView viewWithTag:1001] setText:_detailModel.end_time];
    [(UILabel *)[_detailView viewWithTag:1002] setText:_detailModel.duration];
    [(UILabel *)[_detailView viewWithTag:1003] setText:_detailModel.count];
    [(UILabel *)[_detailView viewWithTag:1004] setText:_detailModel.is_leaveschool];
    [(UILabel *)[_detailView viewWithTag:1005] setText:_detailModel.is_xiaojia];
    [(UILabel *)[_detailView viewWithTag:1006] setText:_detailModel.fd_name];
    [(UILabel *)[_detailView viewWithTag:1007] setText:_detailModel.approval_time];
    [(UILabel *)[_detailView viewWithTag:1008] setText:_detailModel.xiaojia_time];
    
    
    //原因
    [_detailView initReasonView];
    [_detailView.reasonLabel setText:_detailModel.reason];
    NSString *content=_detailModel.reason;
    UIFont *font=[UIFont systemFontOfSize:12];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
  
    [_detailView.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) { 
        make.height.mas_equalTo(contentHeight);
    }];
    
    //[_detailView.reasonLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[_detailView.reasonLabel setNumberOfLines:0];
    //[_detailView.reasonLabel sizeToFit];
    //图片
    if(![_detailModel.img isEqualToString:@""]){
        _detailView.imageArray=[_detailModel.img componentsSeparatedByString:@"|"];
    }
//    _detailView.imageArray=@[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1753994466,2448014264&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1753994466,2448014264&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1753994466,2448014264&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1753994466,2448014264&fm=26&gp=0.jpg"];

    [_detailView initAlbumView];
    
    //课程证明人
    [_detailView initLessonAndProveView];
    [_detailView.lessonLabel setText: _detailModel.lesson];
    [_detailView.zm_nameLabel setText: _detailModel.zm_name];
    if(_detailModel.zm_name!=nil){
        [_detailView.zm_statusLabel setText:[NSString stringWithFormat:@"  %@  ", _detailModel.zm_status] ];
    }
    else{
        [_detailView.zm_statusLabel setHidden:YES];
    }
    
    
    if([_detailModel.zm_status isEqualToString:@"待证明"]){
        [_detailView.zm_statusLabel setTextColor:GKColorRGB(242 , 89 , 75)];
        _detailView.zm_statusLabel.backgroundColor=GKColorRGB(251 , 215 , 209);
    }
    else if([_detailModel.zm_status isEqualToString:@"同意"]||[_detailModel.zm_status isEqualToString:@"已证明"]){
        [_detailView.zm_statusLabel setText:[NSString stringWithFormat:@"  %@  ", @"已证明"] ];
        [_detailView.zm_statusLabel setTextColor:GKColorHEX(0x2c92f5, 1)];
        _detailView.zm_statusLabel.backgroundColor=GKColorRGB(204 , 222 , 253);
    }
    else{
        _detailView.zm_statusLabel.textColor=[UIColor grayColor];
    }
   
    if((![_detailModel.status isEqualToString:@"待审批"])&&[_detailModel.status isEqualToString:@"已驳回"]){
        //驳回
        [_detailView initRejectView];
        [_detailView.rejectLabel setText:_detailModel.reject];
        [_detailView.rejectLabel sizeToFit];
        
    }
    
    
    
    [_scrollView addSubview:_detailView];
    //内容高度
    CGFloat scrollViewHeight = 80.0f;
    for (UIView* view in _scrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    [_scrollView setContentSize:(CGSizeMake(kWidth, scrollViewHeight))];
}

//底部button
-(void) addBtnType:(int) type{
    UIView *btnView=[[UIView alloc] init];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
//    btnView.layer.shadowColor = [UIColor blackColor].CGColor;
//    btnView.layer.shadowOffset = CGSizeMake(0,0);
//    btnView.layer.shadowOpacity = 0.2;
//    btnView.layer.shadowRadius = 2;
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-60-BottomPaddingHeight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(60);
    }];
    
    if(type==1){
        
        UIButton *passBtn=[[UIButton alloc] init];
        passBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [passBtn addTarget:self action:@selector(clickPassBtn:) forControlEvents:UIControlEventTouchUpInside];
        [passBtn setTitle:@"通过" forState:UIControlStateNormal];
        passBtn.layer.cornerRadius=14;
        passBtn.layer.masksToBounds=YES;
        passBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnView addSubview:passBtn];
        [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnView).offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo((kWidth-50)/2);
            make.height.mas_equalTo(40);
        }];
        UIButton *rejectBtn=[[UIButton alloc] init];
        rejectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [rejectBtn addTarget:self action:@selector(clickRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        rejectBtn.layer.cornerRadius=14;
        rejectBtn.layer.masksToBounds=YES;
        rejectBtn.backgroundColor=GKColorRGB(246, 246, 246);
        [rejectBtn setTitleColor:GKColorHEX(0x2c92f5,1) forState:UIControlStateNormal];
        [btnView addSubview:rejectBtn];
        [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnView).offset(10);
            make.left.mas_equalTo((kWidth/2)+10);
            make.width.mas_equalTo((kWidth-50)/2);
            make.height.mas_equalTo(40);
        }];
    }
    else if(type==2){
        UIButton *passBtn=[[UIButton alloc] init];
        passBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [passBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [passBtn setTitle:@"销假" forState:UIControlStateNormal];
        passBtn.layer.cornerRadius=14;
        passBtn.layer.masksToBounds=YES;
        passBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnView addSubview:passBtn];
        [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnView).offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(kWidth-30);
            make.height.mas_equalTo(40);
        }];
    }
    else{
        [btnView removeFromSuperview];
    }
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _scrollView.backgroundColor=[UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        //_scrollView.contentSize =CGSizeMake(0,kHeight+60);
    }
    return _scrollView;
}

//销假
- (void)clickCloseBtn:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进行销假处理" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self verifyLeaveType:@"销假" Status:@"" Reject:@""];
    }])];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//通过
- (void)clickPassBtn:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否同意该学生的请假" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self verifyLeaveType:@"审批" Status:@"通过" Reject:@""];
    }])];
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//驳回
- (void)clickRejectBtn:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"拒绝原因" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      
        textField.placeholder = @"请输入拒绝原因";
    }];
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        [self verifyLeaveType:@"审批" Status:@"驳回" Reject:textField.text];
        
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
 
}


#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryLeaveDetail"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            self->_detailModel=[[LeaveDetailModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
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
#pragma mark - 审批
-(void)verifyLeaveType:(NSString *)type Status:(NSString *)status Reject:(NSString *)reject{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic = [@{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"id":_detailId,@"type":type} mutableCopy];
    if(![status isEqualToString:@""]){
        [paramDic setObject:status forKey:@"status"];
    }
    if(![reject isEqualToString:@""]){
       [paramDic setObject:reject forKey:@"reject"];
    }
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"updateLeave"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //[SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            [SVProgressHUD showSuccessWithStatus:@"审批成功！"];
            LeaveViewController *tempVC=[LeaveViewController new];
            if([self.detailModel.is_leaveschool isEqualToString:@"是"]){
                tempVC.selectIndex=2;
            }
            else{
                tempVC.selectIndex=1;
            }
            NSMutableArray *ViewCtr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            int index = (int)[ViewCtr indexOfObject:self];
            [ViewCtr removeObjectAtIndex:index];
            [ViewCtr removeObjectAtIndex:index-1];
            [ViewCtr addObject:tempVC];
            [self.navigationController setViewControllers:ViewCtr animated:YES];
        }
        else{
            [SVProgressHUD dismiss];
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
}


@end
