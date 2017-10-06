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

+(BNRRoleType)roleType{
    NJDUserInfoMO *m = [self userInfo];
    if (m) {
        if ([m.role.no isEqualToString:@"PTYH"]){
            return BNRRoleTypeRenter;
        }
        if ([m.role.no isEqualToString:@"FD"]) {
            return BNRRoleTypeLandlord;
        }
        if ([m.role.no isEqualToString:@"XGY"]) {
            return BNRRoleTypeTrafficAssistant;
        }
        if ([m.role.no isEqualToString:@"CKRY"]) {
            return BNRRoleTypeWindowClerk;
        }
        return BNRRoleTypeUnknow;
    }
    return BNRRoleTypeUnknow;
}
@end
