//
//  NJDPersonInfoMO+CoreDataProperties.h
//  
//
//  Created by JustinYang on 2017/10/1.
//
//

#import "NJDPersonInfoMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NJDPersonInfoMO (CoreDataProperties)

+ (NSFetchRequest<NJDPersonInfoMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *identityCard;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, copy) NSString *telephoneNumber;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nonatomic) int16_t sex;
@property (nullable, nonatomic, retain) NJDUserInfoMO *belongUserInfo;

@end

NS_ASSUME_NONNULL_END
