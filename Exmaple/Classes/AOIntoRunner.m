//
//  AOIntoRunner.m
//  AOInroRunner
//
//  Created by Alekseenko Oleg on 20.12.13.
//  Copyright (c) 2013 alekoleg. All rights reserved.
//

#import "AOIntoRunner.h"

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
    
}

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block {
    
}

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId toVersion:(NSString *)version block:(IntroBlock)block {
    
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block {
    
}

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block {
    
}

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block {
    
}

//============================================================================================
#pragma mark - Actions -
//--------------------------------------------------------------------------------------------
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

@end
