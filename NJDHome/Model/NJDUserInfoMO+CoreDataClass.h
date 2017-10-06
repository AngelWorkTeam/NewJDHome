//
//  NJDUserInfoMO+CoreDataClass.h
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NJDPersonInfoMO, NJDRoleInfoMO;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,BNRRoleType) {
    BNRRoleTypeUnknow = 0x00,
    BNRRoleTypeLandlord,
    BNRRoleTypeRenter,
    BNRRoleTypeWindowClerk,
    BNRRoleTypeTrafficAssistant
};
@interface NJDUserInfoMO : NSManagedObject
/**
 *在处登入界面之外的地方访问它，程序中总只保持一个userinfo的实体
 */
+(NJDUserInfoMO *)userInfo;
+(void)save;
+(void)deleteAll;
//无实体时，返回unknow
+(BNRRoleType)roleType;
@end

NS_ASSUME_NONNULL_END

#import "NJDUserInfoMO+CoreDataProperties.h"
