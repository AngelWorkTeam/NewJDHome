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

@interface NJDUserInfoMO : NSManagedObject
+(NJDUserInfoMO *)userInfo;
+(void)save;
+(void)deleteAll;
@end

NS_ASSUME_NONNULL_END

#import "NJDUserInfoMO+CoreDataProperties.h"
