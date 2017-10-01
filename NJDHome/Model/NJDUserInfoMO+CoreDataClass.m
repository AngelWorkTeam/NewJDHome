//
//  NJDUserInfoMO+CoreDataClass.m
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDUserInfoMO+CoreDataClass.h"

@implementation NJDUserInfoMO
+(NJDUserInfoMO *)userInfo{
    NSArray *arr = [NJDUserInfoMO MR_findAll];
    if (arr.count >0) {
        return [arr firstObject];
    }
    return nil;
}
+(void)deleteAll{
    [NJDUserInfoMO MR_truncateAll];
}
+(void)save{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
@end
