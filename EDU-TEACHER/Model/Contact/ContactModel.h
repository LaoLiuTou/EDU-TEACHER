//
//  ContactModel.h
//

#import "JSONModel.h"

@interface ContactModel : JSONModel

 
@property (nonatomic,strong) NSString <Optional> *id;//学生id
@property (nonatomic,strong) NSString <Optional> *NM_T;//学生名
@property (nonatomic,strong) NSString <Optional> *SN_T;//学号
@property (nonatomic,strong) NSString <Optional> *PH_P;//电话
@property (nonatomic,strong) NSString <Optional> *I_UPIMG;//头像
@property (nonatomic,strong) NSString <Optional> *USER_ID;//聊天时用到的USER_ID
@property (nonatomic,strong) NSString <Optional> *STATUS;//状态
 
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
