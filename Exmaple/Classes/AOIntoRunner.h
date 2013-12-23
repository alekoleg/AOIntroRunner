//
//  AOIntoRunner.h
//  AOInroRunner
//
//  Created by Alekseenko Oleg on 20.12.13.
//  Copyright (c) 2013 alekoleg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IntroBlock)(void);
typedef BOOL (^IntroConditionBlock) (void);

@interface AOIntoRunner : NSObject

+ (instancetype)sharedRunner;

+ (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block;

+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block;
+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId toVersion:(NSString *)version block:(IntroBlock)block;

+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time block:(IntroBlock)block;
+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)time withCondition:(IntroConditionBlock)condition block:(IntroBlock)block;

+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block;
+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block;

//--------------------------------------------------------------------------------------------
- (void)trackVersion;
@end
