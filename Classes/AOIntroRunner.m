//
//  AOIntroRunner.m
//  AOInroRunner
//
//  Created by Alekseenko Oleg on 20.12.13.
//  Copyright (c) 2013 alekoleg. All rights reserved.
//

#import "AOIntroRunner.h"

NSString * const AOIntroRunnerKeyFirstLaunchVersion = @"AOIntroRunnerKeyFirstLaunchVersion";
NSString * const AOIntroRunnerKeyCurrentVersion = @"AOIntroRunnerKeyCurrentVersion";

NSString * const AOIntroRunnerKeyFirstLaunchVersionIds = @"AOIntroRunnerFirstLaunchIds";
NSString * const AOIntroRunnerKeyUpdateVersionIds = @"AOIntroRunnerKeyUpdateVersionIds";

NSString * const AOIntroRunnerKeyRunBlockTimes = @"AOIntroRunnerKeyRunBlockTimes";
NSString * const AOIntroRunnerKeyRunBlockOnTime = @"AOIntroRunnerKeyRunBlockOnTime";
NSString * const AOIntroRunnerKeyBlockTitle = @"AOIntroRunnerKeyBlockTitle";
NSString * const AOIntroRunnerKeyBlockTimeCount = @"AOIntroRunnerKeyBlockTimeCount";
NSString * const AOIntroRunnerKeyBlockStatus = @"AOIntroRunnerKetBlockStatus";

NSString * const AOIntroRunnerKeyRegularBlocks = @"AOIntroRunnerKeyRegularBlocks";

static AOIntroRunner *_sharedRunner;

@implementation AOIntroRunner {
    NSUserDefaults *_defaults;
}

//============================================================================================
#pragma mark - Init -
//--------------------------------------------------------------------------------------------
- (id)init {
    NSAssert(NO, @"Do not init AOIntroRunner use sharedRunner insted");
    return nil;
}

- (id)initSave {
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

//============================================================================================
#pragma mark - Static Methods -
//--------------------------------------------------------------------------------------------

+ (instancetype)sharedRunner {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRunner = [[AOIntroRunner alloc]initSave];
    });
    return _sharedRunner;
}

+ (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockOnFirstAppLaunchWithId:blockId block:block];
}

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockOnAppUpdateWithId:blockId block:block];
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockWithId:blockId onTime:time block:block];
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockWithId:blockId onTime:time withCondition:condition block:block];
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockWithId:blockId times:times block:block];
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockWithId:blockId times:times withCondition:condition block:block];
}

+ (void)runBlockWithId:(NSString *)blockId block:(IntroBlock)block {
    [[AOIntroRunner sharedRunner]runBlockWithId:blockId block:block];
}

+ (void)setBlockIdCompleted:(NSString *)blockId {
    [[AOIntroRunner sharedRunner]setBlockIdCompleted:blockId];
}

+ (BOOL)isBlockRunned:(NSString *)blockId {
    return [[AOIntroRunner sharedRunner] isBlockRunned:blockId];
}
//============================================================================================
#pragma mark - Actions -
//--------------------------------------------------------------------------------------------
- (void)trackVersion {
    
}

- (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    if ([[self firstLaunchVersion] isEqualToString:[self currentAppVersion]]) {
        NSString *key = AOIntroRunnerKeyFirstLaunchVersionIds;
        [self evalueteBlock:block withBlockId:blockId forKey:key];
    }
}

- (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    if (![[self firstLaunchVersion]isEqualToString:[self currentAppVersion]]) {
        NSString *key = [AOIntroRunnerKeyUpdateVersionIds stringByAppendingFormat:@"_%@", [self currentAppVersion]];
        [self evalueteBlock:block withBlockId:blockId forKey:key];
    }
}


- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    [self runBlockWithId:blockId onTime:time withCondition:NULL block:block];
}

- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    NSMutableDictionary *blockDic = [self blockInfoDicForKey:AOIntroRunnerKeyRunBlockOnTime withBlockId:blockId];
    if (![blockDic[AOIntroRunnerKeyBlockStatus]boolValue]) {
        BOOL resulCondition = !(condition);
        if (condition) {
            resulCondition = condition();
        }
        if (resulCondition) {
            if (time < 1) time = 1;
            NSInteger currentTime = [blockDic[AOIntroRunnerKeyBlockTimeCount]integerValue] + 1;
            if (currentTime == time) {
                blockDic[AOIntroRunnerKeyBlockStatus] = @YES;
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyRunBlockOnTime];
                if (block) {
                    block();
                }
            } else {
                blockDic[AOIntroRunnerKeyBlockTimeCount] = @(currentTime);
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyRunBlockOnTime];
            }
        }
    }
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    [self runBlockWithId:blockId times:times withCondition:NULL block:block];
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
    NSAssert(blockId, @"BlockId cannot be nil");
    NSMutableDictionary *blockDic = [self blockInfoDicForKey:AOIntroRunnerKeyRunBlockTimes withBlockId:blockId];
    if (![blockDic[AOIntroRunnerKeyBlockStatus]boolValue]) {
        BOOL resulCondition = !(condition);
        if (condition) {
            resulCondition = condition();
        }
        if (resulCondition) {
            if (times < 1) times = 1;
            NSInteger currentTime = [blockDic[AOIntroRunnerKeyBlockTimeCount]integerValue] + 1;
            if (currentTime <= times) {
                blockDic[AOIntroRunnerKeyBlockTimeCount] = @(currentTime);
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyRunBlockTimes];
                if (block) {
                    block();
                }
            } else {
                blockDic[AOIntroRunnerKeyBlockStatus] = @YES;
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyRunBlockTimes];
            }
        }
    }
}

- (void)runBlockWithId:(NSString *)blockId block:(IntroBlock)block {
    NSMutableDictionary *info = [self blockInfoDicForKey:AOIntroRunnerKeyRegularBlocks withBlockId:blockId];
    if (![info[AOIntroRunnerKeyBlockStatus]boolValue]) {
        if (block) {
            block();
        }
    }
}

- (void)setBlockIdCompleted:(NSString *)blockId {
    NSMutableDictionary *info = [self blockInfoDicForKey:AOIntroRunnerKeyRegularBlocks withBlockId:blockId];
    info[AOIntroRunnerKeyBlockStatus] = @YES;
    [self saveBlockInfoDic:info forKey:AOIntroRunnerKeyRegularBlocks];
}

- (BOOL)isBlockRunned:(NSString *)blockId {
    //search by all blocks types
    NSMutableDictionary *infoRegular = [self blockInfoDicForKey:AOIntroRunnerKeyRegularBlocks withBlockId:blockId];
    NSMutableDictionary *infoTimes = [self blockInfoDicForKey:AOIntroRunnerKeyRunBlockTimes withBlockId:blockId];
    NSMutableDictionary *infoOnTimes = [self blockInfoDicForKey:AOIntroRunnerKeyRunBlockOnTime withBlockId:blockId];
    NSArray *resuls = @[infoRegular, infoOnTimes, infoTimes];
    for (NSDictionary *dic in resuls) {
        if ([dic[AOIntroRunnerKeyBlockStatus] boolValue]) {
            return YES;
        }
    }
    return NO;
}

//============================================================================================
#pragma mark - Help Methods -
//--------------------------------------------------------------------------------------------

- (NSString *)firstLaunchVersion {
    if (![[NSUserDefaults standardUserDefaults]valueForKey:AOIntroRunnerKeyFirstLaunchVersion]) {
        NSString *path = [[[NSBundle mainBundle]bundlePath]stringByDeletingLastPathComponent];
        NSString *documents = [path stringByAppendingPathComponent:@"Documents"];
        NSError *error = nil;
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:documents error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        NSDateComponents *components = [[NSCalendar currentCalendar]components:NSDayCalendarUnit fromDate:dic[NSFileCreationDate] toDate:[NSDate date] options:0];
        BOOL result = (components.day < 1);
        NSString *verion = result ? [self currentAppVersion] : @"-0.0.1";
        [[NSUserDefaults standardUserDefaults]setObject:verion forKey:AOIntroRunnerKeyFirstLaunchVersion];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return [[NSUserDefaults standardUserDefaults]valueForKey:AOIntroRunnerKeyFirstLaunchVersion];
}

- (NSString *)currentAppVersion {
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
}

- (void)evalueteBlock:(IntroBlock)block withBlockId:(NSString *)blockId forKey:(NSString *)key {
    NSMutableArray *ids = [[[NSUserDefaults standardUserDefaults]valueForKey:key]mutableCopy];
    if (!ids) ids = [NSMutableArray array];
    if (![ids containsObject:blockId]) {
        [ids addObject:blockId];
        [[NSUserDefaults standardUserDefaults]setObject:ids forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        if (block) {
            block();
        }
    }
}

- (NSMutableDictionary *)blockInfoDicForKey:(NSString *)key withBlockId:(NSString *)blockId {
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]valueForKey:key]mutableCopy];
    if (!array) array = [NSMutableArray array];
    NSMutableDictionary *blockDic = nil;
    for (NSDictionary *dic in array) {
        if ([dic[AOIntroRunnerKeyBlockTitle] isEqualToString:blockId]) {
            blockDic = [dic mutableCopy];
            break;
        }
    }
    
    if (!blockDic) {
        blockDic = [NSMutableDictionary dictionaryWithObjects:@[blockId, @0, @NO] forKeys:@[AOIntroRunnerKeyBlockTitle, AOIntroRunnerKeyBlockTimeCount, AOIntroRunnerKeyBlockStatus]];
    }
    return blockDic;
}

- (void)saveBlockInfoDic:(NSDictionary *)dicBlock forKey:(NSString *)key {
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults]valueForKey:key]mutableCopy];
    if (!array) array = [NSMutableArray array];
    BOOL found = NO;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        if ([dic[AOIntroRunnerKeyBlockTitle] isEqualToString:dicBlock[AOIntroRunnerKeyBlockTitle]]) {
            [array replaceObjectAtIndex:i withObject:dicBlock];
            found = YES;
            break;
        }
    }
    
    if (!found) {
        [array addObject:dicBlock];
    }
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
