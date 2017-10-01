//
//  NJDUserInfoMO+CoreDataProperties.h
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDUserInfoMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NJDUserInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDUserInfoMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *realName;
@property (nonatomic) BOOL isdeleted;
@property (nonatomic) BOOL isLocked;
@property (nullable, nonatomic, copy) NSString *userPassword;
@property (nullable, nonatomic, copy) NSString *id;
@property (nonatomic) BOOL isLogin;
@property (nullable, nonatomic, retain) NJDRoleInfoMO *role;
@property (nullable, nonatomic, retain) NJDPersonInfoMO *personInfo;

@end

NS_ASSUME_NONNULL_END
