//
//  ContactModel.m 
//

#import "ContactModel.h"
#import "NSString+Utils.h"//category

@implementation ContactModel

 
- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
