//
//  NJDPersonInfoMO+CoreDataProperties.m
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDPersonInfoMO+CoreDataProperties.h"

@implementation NJDPersonInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDPersonInfoMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NJDPersonInfo"];
}

@dynamic id;
@dynamic identityCard;
@dynamic name;
@dynamic nation;
@dynamic state;
@dynamic telephoneNumber;
@dynamic userId;
@dynamic sex;
@dynamic belongUserInfo;

@end
