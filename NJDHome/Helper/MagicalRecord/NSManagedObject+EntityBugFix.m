//
//  NSManagedObject+EntityBugFix.m
//  HETSleepDevice
//
//  Created by JustinYang on 2017/8/22.
//  Copyright © 2017年 JustinYang. All rights reserved.
//

#import "NSManagedObject+EntityBugFix.h"
#import <objc/runtime.h>
#import <MagicalRecord/MagicalRecord.h>
@implementation NSManagedObject (EntityBugFix)
+(void)load{
    Method m1 = class_getClassMethod([self class], @selector(MR_entityName));
    Method m2 = class_getClassMethod([self class], @selector(MR_entityNameHook));
    method_exchangeImplementations(m1, m2);
}
+(NSString *)MR_entityNameHook{
    if ([self respondsToSelector:@selector(fetchRequest)]) {
        NSFetchRequest *request = [self fetchRequest];
        return request.entityName;
    }
    
    return [self MR_entityNameHook];

}

@end
