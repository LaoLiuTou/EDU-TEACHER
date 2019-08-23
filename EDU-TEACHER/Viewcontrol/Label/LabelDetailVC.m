//
//  LabelDetailVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LabelDetailVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "LabelDetailView.h"
#import "LabelModel.h"
#import "SelectStudentVC.h"
#import "UIImageView+WebCache.h"
#import "LabelStuCell.h"
@interface LabelDetailVC ()<UITableViewDataSource, UITableViewDelegate,LabelDetailDelegate>
@property (nonatomic, strong) LabelDetailView *labelDetailView;
@property (nonatomic, strong) LabelModel *labelModel;

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray   *listStuArray;
@property (nonatomic, strong) NSMutableDictionary   *listIdDic;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation LabelDetailVC{
    int topHeight; 
    NSString *xs_names;
    NSString *xs_ids;
    NSString *isloading;
    NSString *notificationName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:GKColorRGB(246, 246, 246)];
    [self initNavBar];
    [self getNetworkData];
    //选择学生
    xs_names=@"";
    xs_ids=@"";
    isloading=@"0";
    //注册通知：
    notificationName=@"SelectStudentLabel";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"标签查看";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    LabelDetailView *labelDetailView = [[LabelDetailView alloc]init];
    self.labelDetailView=labelDetailView;
    self.labelDetailView.delegate=self;
    topHeight=[self.labelDetailView initModel:self.labelModel];
    [self.view addSubview:self.labelDetailView];
    self.labelDetailView.frame = CGRectMake(0, kNavBarHeight, kWidth, topHeight);
    
    
    [self.view addSubview:self.tableView];
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-5-BottomPaddingHeight);
        make.left.equalTo(self.view).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(40);
    }];
}
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn=[[UIButton alloc] init];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_saveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius=16;
        _saveBtn.layer.masksToBounds=YES;
        _saveBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, topHeight+kNavBarHeight+1, kWidth, kHeight-kNavBarHeight-topHeight-60-BottomPaddingHeight)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 50.0f;
    }
    return _tableView;
}

#pragma mark - 数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listStuArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *stuDic=_listStuArray[indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",[stuDic objectForKey:@"id"]];
    LabelStuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[LabelStuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[stuDic objectForKey:@"xs_image"]];
    
    
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
    cell.nameLabel.text=[stuDic objectForKey:@"xs_name"];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 选择学生
- (void)clickSelectStuBtn:(UIButton *)btn {
    NSLog(@"clickSelectStuBtn");
     [self.view endEditing:YES];
    xs_names=@"";
    xs_ids=@"";
    SelectStudentVC *jumpVC= [SelectStudentVC new];
    jumpVC.type=@"class";
    jumpVC.values=@{@"class":self.listIdDic};
    jumpVC.notificationName=notificationName;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    //tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
   
    if([isloading isEqualToString:@"0"]){
        [self updateItem:@"0"];
    }
    
}
#pragma mark - 发布
- (void)clickSaveBtn:(UIButton *)btn {
    NSLog(@"clickPublishBtn");
    if([self.labelDetailView.nameLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入标签名称！"];
    }
    else{
        [self updateItem:@"1"];
    }
}
#pragma mark - 网络请求获取数据
-(void)updateItem:(NSString *) type{
    isloading=@"1";
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:xs_ids forKey:@"xs_ids"];
    [paramDic setObject:self.detailId forKey:@"id"];
    [paramDic setObject:self.labelDetailView.nameLabel.text forKey:@"name"];
    [paramDic setObject:self.labelDetailView.remarkLabel.text forKey:@"remark"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"updateTag"];
    
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        self->isloading=@"0";
        NSDictionary *resultDic=responseObject;
        if([type isEqualToString:@"1"]){
            if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
                
                [[LTAlertView new] showOneChooseAlertViewMessage:@"修改成功！"];
                [self getNetworkData];
                
                
            }
            else{
                [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            }
        }
        else if([type isEqualToString:@"0"]){
            [self refreshListData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        self->isloading=@"0";
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
    
}
#pragma mark - 网络请求获取数据
-(void)refreshListData{
    
    self.listIdDic=[NSMutableDictionary new];
    self.listStuArray=[NSMutableArray new];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryTagDetail"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            LabelModel *model=[[LabelModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.labelModel=model;
            self.listStuArray=[model.xs_list mutableCopy];
            for(int i=0;i<self.listStuArray.count;i++){
                NSString *class_id=[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"class_id"]];
                if([self.listIdDic containsObjectForKey:class_id]){
                    NSMutableArray *tempArray=[self.listIdDic objectForKey:class_id];
                    [tempArray addObject:[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"id"]]];
                }
                else{
                    NSMutableArray *tempArray=[NSMutableArray new];
                    [tempArray addObject:[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"id"]]];
                    [self.listIdDic setObject:tempArray forKey:class_id];
                }
                
            }
            [self.tableView reloadData];
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
#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    
    self.listIdDic=[NSMutableDictionary new];
    self.listStuArray=[NSMutableArray new];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryTagDetail"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
           
            LabelModel *model=[[LabelModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.labelModel=model;
            self.listStuArray=[model.xs_list mutableCopy];
            for(int i=0;i<self.listStuArray.count;i++){
                NSString *class_id=[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"class_id"]];
                if([self.listIdDic containsObjectForKey:class_id]){
                    NSMutableArray *tempArray=[self.listIdDic objectForKey:class_id];
                    [tempArray addObject:[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"id"]]];
                }
                else{
                    NSMutableArray *tempArray=[NSMutableArray new];
                    [tempArray addObject:[NSString stringWithFormat:@"%@",[self.listStuArray[i] objectForKey:@"id"]]];
                    [self.listIdDic setObject:tempArray forKey:class_id];
                }
                
                
            }
            
            [self initView];
            [self.tableView reloadData];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
