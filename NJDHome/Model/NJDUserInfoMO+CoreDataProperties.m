//
//  NJDUserInfoMO+CoreDataProperties.m
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDUserInfoMO+CoreDataProperties.h"

@implementation NJDUserInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDUserInfoMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NJDUserInfo"];
}

@dynamic userId;
@dynamic token;
@dynamic username;
@dynamic realName;
@dynamic isdeleted;
@dynamic isLocked;
@dynamic userPassword;
@dynamic id;
@dynamic isLogin;
@dynamic role;
@dynamic personInfo;

@end
