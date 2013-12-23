//
//  AOIntoRunner.m
//  AOInroRunner
//
//  Created by Alekseenko Oleg on 20.12.13.
//  Copyright (c) 2013 alekoleg. All rights reserved.
//

#import "AOIntoRunner.h"

NSString * const AOIntoRunnerKeyFirstLaunchVersion = @"AOIntoRunnerKeyFirstLaunchVersion";
NSString * const AOIntoRunnerKeyCurrentVersion = @"AOIntoRunnerKeyCurrentVersion";

static AOIntoRunner *_sharedRunner;

@implementation AOIntoRunner {
    NSUserDefaults *_defaults;
}

//============================================================================================
#pragma mark - Init -
//--------------------------------------------------------------------------------------------
- (id)init {
    NSAssert(NO, @"Do not init AOIntoRunner use sharedRunner insted");
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
        _sharedRunner = [[AOIntoRunner alloc]initSave];
    });
    return _sharedRunner;
}

+ (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockOnFirstAppLaunchWithId:blockId block:block];
}

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockOnAppUpdateWithId:blockId block:block];
}

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId toVersion:(NSString *)version block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockOnAppUpdateWithId:block toVersion:version block:block];
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockWithId:blockId times:time block:block];
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockWithId:block onTime:time withCondition:condition block:block];
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockWithId:blockId times:times block:block];
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    [[AOIntoRunner sharedRunner]runBlockWithId:blockId times:times withCondition:condition block:block];
}

//============================================================================================
#pragma mark - Actions -
//--------------------------------------------------------------------------------------------
- (void)trackVersion {
    
}

- (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block {
    
}

- (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    
}

- (void)runBlockOnAppUpdateWithId:(NSString *)blockId toVersion:(NSString *)version block:(IntroBlock)block {
    
}

- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    
}

- (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    
}

- (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
}

//============================================================================================
#pragma mark - Help Methods -
//--------------------------------------------------------------------------------------------

- (NSString *)firstLaunchVersion {
    if (![[NSUserDefaults standardUserDefaults]valueForKey:AOIntoRunnerKeyFirstLaunchVersion]) {
        NSString *path = [[[NSBundle mainBundle]bundlePath]stringByDeletingLastPathComponent];
        NSString *documents = [path stringByAppendingPathComponent:@"Documents"];
        NSError *error = nil;
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:documents error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        NSDateComponents *components = [[NSCalendar currentCalendar]components:NSDayCalendarUnit fromDate:dic[NSFileCreationDate] toDate:[NSDate date] options:0];
        BOOL result = (components.day < 0);
        NSString *verion = result ? [self currentAppVersion] : @"-0.0.1";
        [[NSUserDefaults standardUserDefaults]setObject:verion forKey:AOIntoRunnerKeyFirstLaunchVersion];
    }
    return [[NSUserDefaults standardUserDefaults]valueForKey:AOIntoRunnerKeyFirstLaunchVersion];
}

- (NSString *)currentAppVersion {
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
}

@end
