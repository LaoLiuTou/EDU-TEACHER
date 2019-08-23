//
//  StudentModel.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "JSONModel.h"

@interface StudentModel : JSONModel
 
@property (nonatomic,strong) NSString <Optional> *id;//学生id
@property (nonatomic,strong) NSString <Optional> *NM_T;        //姓名
@property (nonatomic,strong) NSString <Optional> *SN_T;   //学号
@property (nonatomic,strong) NSString <Optional> *PH_P;    //电话
@property (nonatomic,strong) NSString <Optional> *I_UPIMG;    //头像
@property (nonatomic,strong) NSString <Optional> *USER_ID;      //聊天时用的USER_ID
@property (nonatomic,strong) NSString <Optional> *att_status;    //关注状态:已关注、未关注
@property (nonatomic,strong) NSString <Optional> *school_name;  //学校名称
@property (nonatomic,strong) NSString <Optional> *xueyuan_name;    //学院名称
@property (nonatomic,strong) NSString <Optional> *zhuanye_name;      //专业名称
@property (nonatomic,strong) NSString <Optional> *class_name;   //班级名称
@property (nonatomic,strong) NSString <Optional> *sushe_name;        //宿舍名称
@property (nonatomic,strong) NSString <Optional> *SE_LV;        //性别
@property (nonatomic,strong) NSString <Optional> *NT_LV;     //民族
@property (nonatomic,strong) NSString <Optional> *BD_D;  //出生日期
@property (nonatomic,strong) NSString <Optional> *SF_T;  //身份证
@property (nonatomic,strong) NSString <Optional> *PM_LV; //培养方式
@property (nonatomic,strong) NSString <Optional> *XJ_LV;    //学籍状态
@property (nonatomic,strong) NSString <Optional> *XZ_T;    //学制
@property (nonatomic,strong) NSString <Optional> *RD_D;     //入学日期
@property (nonatomic,strong) NSString <Optional> *PL_LV;    //政治面貌
@property (nonatomic,strong) NSString <Optional> *ST_Z2;    //生源地
@property (nonatomic,strong) NSString <Optional> *STATUS;        //状态：上课中；请假中；异动中(未签到)；异动中(未销假)；休息中~~~~
@property (nonatomic,strong) NSDictionary <Optional> *STATUS_INFO;

//{                //状态信息：上课中：显示课程签到名称；请假中~~~~：显示请假类型+请假时间；异动中(未签到)：显示未签到课程签到名称；异动中(未销假)：显示请假类型+请假时间；休息中：显示休息中
//    "id": 1461,
//    "type": "病假",
//    "start_time": "2019-06-27 15:03:00",
//    "end_time": "2019-09-27 15:03:00"
//}


- (instancetype)initWithDic:(NSDictionary *)dic;
@end
