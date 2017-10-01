//
//  NJDRoleInfoMO+CoreDataProperties.m
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDRoleInfoMO+CoreDataProperties.h"

@implementation NJDRoleInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDRoleInfoMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NJDRoleInfo"];
}

@dynamic isSystem;
@dynamic name;
@dynamic no;
@dynamic id;
@dynamic belongUserInfo;

@end
