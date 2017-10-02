//
//  NJDRoleInfoMO+CoreDataProperties.h
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDRoleInfoMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NJDRoleInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDRoleInfoMO *> *)fetchRequest;

@property (nonatomic) BOOL isSystem;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *no;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, retain) NJDUserInfoMO *belongUserInfo;

@end

NS_ASSUME_NONNULL_END
