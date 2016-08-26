//
//  AOIntroRunner.m
//  AOInroRunner
//
//  Created by Alekseenko Oleg on 20.12.13.
//  Copyright (c) 2013 alekoleg. All rights reserved.
//

#import "AOIntroRunner.h"

// versions
NSString * const AOIntroRunnerKeyFirstLaunchVersion = @"AOIntroRunnerKeyFirstLaunchVersion";
NSString * const AOIntroRunnerKeyCurrentVersion = @"AOIntroRunnerKeyCurrentVersion";

// values
NSString * const AOIntroRunnerKeyBlockTitle = @"AOIntroRunnerKeyBlockTitle";
NSString * const AOIntroRunnerKeyBlockTimeCount = @"AOIntroRunnerKeyBlockTimeCount";
NSString * const AOIntroRunnerKeyBlockStatus = @"AOIntroRunnerKetBlockStatus";

// block store key
NSString * const AOIntroRunnerKeyBlocks = @"AOIntroRunnerKeyBlocks";
// user defaults suite name
NSString * const AOIntroRunnedSuiteName = @"com.introrunner.suitename";

static AOIntroRunner *_sharedRunner;

@interface AOIntroRunner ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation AOIntroRunner

//============================================================================================
#pragma mark - Init -
//--------------------------------------------------------------------------------------------
- (id)init {
    NSAssert(NO, @"Do not init AOIntroRunner use sharedRunner insted");
    return nil;
}

- (id)initSave {
    if (self = [super init]) {
        self.defaults = [[NSUserDefaults alloc] initWithSuiteName:AOIntroRunnedSuiteName];
        [self p_migrateFromStandartUserDefaults];
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

+ (void)clear {
    return [[AOIntroRunner sharedRunner] clearSavedIds];
}

//============================================================================================
#pragma mark - Actions -
//--------------------------------------------------------------------------------------------

- (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    if ([[self firstLaunchVersion] isEqualToString:[self currentAppVersion]]) {
        [self evalueteBlock:block withBlockId:blockId forKey:AOIntroRunnerKeyBlocks];
    }
}

- (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    if (![[self firstLaunchVersion]isEqualToString:[self currentAppVersion]]) {
        [self evalueteBlock:block withBlockId:blockId forKey:AOIntroRunnerKeyBlocks];
    }
}


- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    [self runBlockWithId:blockId onTime:time withCondition:NULL block:block];
}

- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    NSAssert(blockId, @"BlockId cannot be nil");
    NSMutableDictionary *blockDic = [self blockInfoDicForKey:AOIntroRunnerKeyBlocks withBlockId:blockId];
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
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyBlocks];
                if (block) {
                    block();
                }
            } else {
                blockDic[AOIntroRunnerKeyBlockTimeCount] = @(currentTime);
                [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyBlocks];
            }
        }
    }
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    [self runBlockWithId:blockId times:times withCondition:NULL block:block];
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
    NSAssert(blockId, @"BlockId cannot be nil");
    NSMutableDictionary *blockDic = [self blockInfoDicForKey:AOIntroRunnerKeyBlocks withBlockId:blockId];
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
                if (block) {
                    block();
                }
            }
            blockDic[AOIntroRunnerKeyBlockStatus] = @(currentTime == times);
            [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyBlocks];
        }
    }
}

- (void)runBlockWithId:(NSString *)blockId block:(IntroBlock)block {
    NSMutableDictionary *info = [self blockInfoDicForKey:AOIntroRunnerKeyBlocks withBlockId:blockId];
    if (![info[AOIntroRunnerKeyBlockStatus]boolValue]) {
        if (block) {
            block();
        }
    }
}

- (void)setBlockIdCompleted:(NSString *)blockId {
    NSMutableDictionary *info = [self blockInfoDicForKey:AOIntroRunnerKeyBlocks withBlockId:blockId];
    info[AOIntroRunnerKeyBlockStatus] = @YES;
    [self saveBlockInfoDic:info forKey:AOIntroRunnerKeyBlocks];
}

- (BOOL)isBlockRunned:(NSString *)blockId {
    //search by all blocks types
    NSDictionary *dic = [self blockInfoDicForKey:AOIntroRunnerKeyBlocks withBlockId:blockId];
    return [dic[AOIntroRunnerKeyBlockStatus] boolValue];
}

- (void)clearSavedIds {
    [self.defaults removeSuiteNamed:AOIntroRunnedSuiteName];
}

//============================================================================================
#pragma mark - Help Methods -
//--------------------------------------------------------------------------------------------

- (NSString *)firstLaunchVersion {
    if (![self.defaults valueForKey:AOIntroRunnerKeyFirstLaunchVersion]) {
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSError *error = nil;
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:documents error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                       fromDate:dic[NSFileCreationDate]
                                                                         toDate:[NSDate date]
                                                                        options:0];
        BOOL result = (components.day < 1);
        NSString *verion = result ? [self currentAppVersion] : @"-0.0.1";
        [self.defaults setObject:verion forKey:AOIntroRunnerKeyFirstLaunchVersion];
        [self.defaults synchronize];
    }
    return [self.defaults valueForKey:AOIntroRunnerKeyFirstLaunchVersion];
}

- (NSString *)currentAppVersion {
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
}

- (void)evalueteBlock:(IntroBlock)block withBlockId:(NSString *)blockId forKey:(NSString *)key {
    NSMutableDictionary *dic = [self blockInfoDicForKey:key withBlockId:blockId];
    if (![dic[AOIntroRunnerKeyBlockStatus] boolValue]) {
        if (block) {
            block();
        }
        dic[AOIntroRunnerKeyBlockStatus] = @YES;
        [self saveBlockInfoDic:dic forKey:key];
    }
}

- (NSMutableDictionary *)blockInfoDicForKey:(NSString *)key withBlockId:(NSString *)blockId {
    NSMutableArray *array = [[self.defaults valueForKey:key]mutableCopy];
    if (!array) array = [NSMutableArray array];
    NSMutableDictionary *blockDic = nil;
    for (NSDictionary *dic in array) {
        if ([dic[AOIntroRunnerKeyBlockTitle] isEqualToString:blockId]) {
            blockDic = [dic mutableCopy];
            break;
        }
    }
    
    if (!blockDic) {
        blockDic = [NSMutableDictionary dictionaryWithObjects:@[blockId, @0, @NO]
                                                      forKeys:@[AOIntroRunnerKeyBlockTitle,
                                                                AOIntroRunnerKeyBlockTimeCount,
                                                                AOIntroRunnerKeyBlockStatus]];
    }
    return blockDic;
}

- (void)saveBlockInfoDic:(NSDictionary *)dicBlock forKey:(NSString *)key {
    NSMutableArray *array = [[self.defaults valueForKey:key]mutableCopy];
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
    [self.defaults setObject:array forKey:key];
    [self.defaults synchronize];
}

- (void)p_migrateFromStandartUserDefaults {

    void (^migrateKey)(NSString *key) = ^(NSString *key) {

        id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (object) {
            [self.defaults setObject:object forKey:key];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    };
    migrateKey(AOIntroRunnerKeyFirstLaunchVersion);
    migrateKey(AOIntroRunnerKeyCurrentVersion);

    void (^migrateIdsToDic)(NSString *key) = ^(NSString *key) {
        NSArray *ids = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        for (NSString *blockId in ids) {
            NSDictionary *dic = @{ AOIntroRunnerKeyBlockTitle : blockId,
                                   AOIntroRunnerKeyBlockTimeCount : @1,
                                   AOIntroRunnerKeyBlockStatus : @YES };
            [self saveBlockInfoDic:dic forKey:AOIntroRunnerKeyBlocks];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    };

    migrateIdsToDic(@"AOIntroRunnerFirstLaunchIds");
    migrateIdsToDic([@"AOIntroRunnerKeyUpdateVersionIds" stringByAppendingFormat:@"_%@", [self currentAppVersion]]);

    void (^migrateOldArrayKeyToNew)(NSString *key) = ^(NSString *key) {
        NSArray *dics = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        for (NSMutableDictionary *blockDic in dics) {
            [self saveBlockInfoDic:blockDic forKey:AOIntroRunnerKeyBlocks];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    };
    migrateOldArrayKeyToNew(@"AOIntroRunnerKeyRunBlockTimes");
    migrateOldArrayKeyToNew(@"AOIntroRunnerKeyRunBlockOnTime");
    migrateOldArrayKeyToNew(@"AOIntroRunnerKeyRegularBlocks");

    [self.defaults synchronize];
}

@end
