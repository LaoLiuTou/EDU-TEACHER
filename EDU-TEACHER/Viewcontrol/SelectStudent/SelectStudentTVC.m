//
//  SelectStudentViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/8.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SelectStudentTVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "GKWBListViewController.h"
#import "SelectStudentCell.h"
#import "SelectStudentModel.h"
@interface SelectStudentTVC ()<UITableViewDataSource, UITableViewDelegate,GKPageListViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableDictionary  *selectDic;
@property (nonatomic, copy) void(^listScrollViewDidScroll)(UIScrollView *scrollView);
@end

@implementation SelectStudentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self getNetworkData];
}

#pragma mark - 初始化搜索视图
- (void)initView{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectBtn];
    
    //去掉多余横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //去掉横线
    //self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorColor = GKColorRGB(246, 246, 246);
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navigationBar.hidden = YES;
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, kWidth, kHeight-kNavBarHeight-150-BottomPaddingHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = 40.0f;
    }
    return _tableView;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, kHeight-kNavBarHeight-140-BottomPaddingHeight, kWidth-40*2, 40)];
        _selectBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setTitle:@"完成" forState:UIControlStateNormal];
        _selectBtn.layer.cornerRadius=16;
        _selectBtn.layer.masksToBounds=YES;
        _selectBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _selectBtn;
}
#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SelectStudentModel *model=_sectionArray[section];
    if ([model.extend isEqualToString:@"extend"]) {
       return [_dataArray[section] count];
        
    } else {
        return 0;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SelectStudentModel *model=_sectionArray[section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];//创建一个视图
    headerView.backgroundColor= [UIColor whiteColor];
    
    //图片
    UIButton *iconButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 13, 24, 24)];
    [iconButton addTarget:self action:@selector(sectionSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    if([model.status isEqualToString:@"select"]){
        [iconButton setBackgroundImage: [UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }
    else{
        [iconButton setBackgroundImage: [UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    iconButton.tag=100+section;
    [headerView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.top.equalTo(headerView).offset(13);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    if([self.select isEqualToString:@"0"]){
        [iconButton setHidden:YES];
    }
    else{
        [iconButton setHidden:NO];
    }
        
    
    UILabel *nameLabel=[[UILabel alloc]init];
    [nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    [nameLabel setText:model.NM_T];
    nameLabel.textColor=[UIColor blackColor];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if([self.select isEqualToString:@"0"]){
            make.left.equalTo(headerView).offset(15);
            make.width.mas_equalTo(kWidth-30);
        }
        else{
            make.left.equalTo(iconButton.mas_right).offset(10);
            make.width.mas_equalTo(kWidth-70);
        }
        make.top.equalTo(headerView).offset(0);
        
        make.height.mas_equalTo(50);
    }];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kWidth, 0.5)];
    bottomLine.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:bottomLine];
    
    headerView.tag=1000+section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}
//section点击
- (void)sectionClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag%1000;
    SelectStudentModel *model=_sectionArray[index];
  
    if ([model.extend isEqualToString:@"extend"]) {
        model.extend = @"unextend";
        
    } else {
        model.extend = @"extend";
    }
    // 刷新单独一组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
//section选择
- (void)sectionSelectClick:(UIButton *)sender{
    int index = sender.tag%100;
    SelectStudentModel *model=_sectionArray[index];
    
    if([model.status isEqualToString:@"select"]){
        model.status = @"unselect";
        
    } else {
        model.status = @"select";
    }
    for(SelectStudentModel *temp in _dataArray[index]){
        temp.status=model.status;
    }
    // 刷新单独一组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
//完成
- (void)clickSelectBtn:(UIButton *)sender{
    _selectDic=@{}.mutableCopy;
    NSMutableArray *titleArray=[NSMutableArray new];
    NSMutableArray *titleIdArray=[NSMutableArray new];
    NSMutableArray *valueArray=[NSMutableArray new];
    NSMutableArray *stuNameArray=[NSMutableArray new];
    NSMutableDictionary *tempDic=[NSMutableDictionary new];
    
    //NSMutableArray *tempstuNameArray=[NSMutableArray new];
    for(int index=0;index< [_dataArray count];index++){
        NSMutableArray *tempvalueArray=[NSMutableArray new];
        BOOL selected=NO;
        for(SelectStudentModel *tempModel in _dataArray[index]){
            if([tempModel.status isEqualToString:@"select"]){
                selected=YES;
                [tempvalueArray addObject:[NSString stringWithFormat:@"%@",tempModel.id]];
                //[tempstuNameArray addObject:tempModel.NM_T];
                [valueArray addObject:[NSString stringWithFormat:@"%@",tempModel.id]];
                [stuNameArray addObject:tempModel.NM_T];
            }
        }
        if(selected){
           SelectStudentModel *tempModel=_sectionArray[index];
            [titleArray addObject:tempModel.NM_T];
            [titleIdArray addObject:[NSString stringWithFormat:@"%@",tempModel.id]];
            [tempDic setObject:tempvalueArray forKey:[NSString stringWithFormat:@"%@",tempModel.id]];
            //[tempArray addObject:@{tempModel.id:tempvalueArray}];
            //[stuNameArray addObject:@{tempModel.NM_T:tempstuNameArray}];
        }
    }
    [_selectDic setObject:self.type forKey:@"type"];
    [_selectDic setObject:titleArray forKey:@"title"];
    [_selectDic setObject:titleIdArray forKey:@"titleId"];
    [_selectDic setObject:valueArray forKey:@"studentId"];
    [_selectDic setObject:stuNameArray forKey:@"studentName"];
    [_selectDic setObject:tempDic forKey:@"tempValue"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:self.notificationName object:nil userInfo:self.selectDic]];
     [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectStudentModel *model=_dataArray[indexPath.section][indexPath.row];
    NSString *cellIde=[NSString stringWithFormat:@"listCell%@",model.id];
    SelectStudentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[SelectStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text =model.NM_T;
    cell.status=model.status;
    if([cell.status isEqualToString:@"select"]){
        [cell chageStatus:@"select"];
    }
    else{
        [cell chageStatus:@"unselect"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectStudentCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    SelectStudentModel *model=_dataArray[indexPath.section][indexPath.row];
    if(![self.sub isEqualToString:@"1"]){//可选
        
        
        
        if([self.select isEqualToString:@"0"]){
            for(int index=0;index< [_dataArray count];index++){
                for(SelectStudentModel *tempModel in _dataArray[index]){
                    if([tempModel.status isEqualToString:@"select"]&&model!=tempModel){
                        tempModel.status=@"unselect";
                    }
                }
            }
            if([cell.status isEqualToString:@"select"]){
                cell.status=@"unselect";
                model.status=@"unselect";
            }
            else{
                cell.status=@"select";
                model.status=@"select";
                
            }
            [self.tableView reloadData];
        }
        else{
            if([cell.status isEqualToString:@"select"]){
                cell.status=@"unselect";
                model.status=@"unselect";
            }
            else{
                cell.status=@"select";
                model.status=@"select";
                
            }
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }
    

    
    

    
}
#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewDidScroll = callback;
}


#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    
    _dataArray=@[].mutableCopy;
    _sectionArray=@[].mutableCopy;
   
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryTagClassList"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            resultDic=[resultDic objectForKey:@"Result"];
            if([resultDic count]>0){
                NSArray *tagArray = [resultDic objectForKey:self.type];
                for (NSDictionary *tagDic in tagArray) {
                    //section
                    NSMutableDictionary *temp=[NSMutableDictionary new];
                    [temp setObject:@"unselect" forKey:@"status"];
                    [temp setObject:@"extend" forKey:@"extend"];
                    [temp setObject:[tagDic objectForKey:@"NM_T"] forKey:@"NM_T"];
                    [temp setObject:[tagDic objectForKey:@"id"] forKey:@"id"];
                    SelectStudentModel *model=[[SelectStudentModel alloc] initWithDic:temp];
                    if([[self.value allKeys] containsObject:[NSString stringWithFormat:@"%@",[tagDic objectForKey:@"id"]]]){
                        model.status=@"select";
                    }
                    else{
                        model.status=@"unselect";
                    }
                    [self->_sectionArray addObject:model];
                    
                    //row
                    NSMutableArray *tempArray=[NSMutableArray new];
                    for(NSDictionary *tempDic in [tagDic objectForKey:@"xs_list"]){
                        NSMutableDictionary *temp=[tempDic mutableCopy];
                        SelectStudentModel *model=[[SelectStudentModel alloc] initWithDic:temp];
                        NSArray *rowValue=[self.value objectForKey:[NSString stringWithFormat:@"%@",[tagDic objectForKey:@"id"]]];
                        if([rowValue containsObject:model.id]){
                            model.status=@"select";
                        }
                        else{
                            model.status=@"unselect";
                        }
                        [tempArray addObject:model ];
                    }
                    [self->_dataArray addObject:tempArray];
                }
                [self initView];
                
            }
            else{
                
            }
            
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
