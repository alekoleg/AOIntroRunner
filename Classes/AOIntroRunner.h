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

NS_ASSUME_NONNULL_BEGIN

/**
 *  Helper to run your code once or on some conditions
 */
@interface AOIntroRunner : NSObject

// run code only on first App Launch
+ (void)runBlockOnFirstAppLaunchWithId:(NSString *)blockId block:(IntroBlock)block;

// run code only if the app was updated
+ (void)runBlockOnAppUpdateWithId:(NSString *)blockId block:(IntroBlock)block;

/**
 *  Run block only on certain time
 *  @blockId - unic identifier
 *  @onTime - time on with block will be performed
 *  @block - code to be run
 */
+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)onTime block:(IntroBlock)block;
/**
 *  Run block only on certain time if condition is met
 *  @blockId - unic identifier
 *  @onTime - time on with block will be performed
 *  @condition - condition
 *  @block - code to be run
 */
+ (void)runBlockWithId:(NSString *)blockId onTime:(NSUInteger)onTime withCondition:(IntroConditionBlock)condition block:(IntroBlock)block;

/**
 *  Run block N-times
 *  @blockId - unic identifier
 *  @time - indicate how many times block shoud be performed
 *  @block - code to be run
 */
+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times block:(IntroBlock)block;

/**
 *  Run block N-times
 *  @blockId - unic identifier
 *  @time - indicate how many times block shoud be performed
 *  @condition - condition to perform block
 *  @block - code to be run
 */
+ (void)runBlockWithId:(NSString *)blockId times:(NSUInteger)times withCondition:(IntroConditionBlock)condition block:(IntroBlock)block;

/**
 *  Run block if blockId is NOT explicitly marked as Completed via setBlockIdCompleted:
 *  @blockId - unic identifier
 *  @block - code to be run
 */
+ (void)runBlockWithId:(NSString *)blockId block:(IntroBlock)block;

/**
 *  Explicitly mark as Completed blockId.
 *  @blockId - unic identifier
 */
+ (void)setBlockIdCompleted:(NSString *)blockId;

/**
 *  Where is block runned
 *  @blockId - unic identifier
 */
+ (BOOL)isBlockRunned:(NSString *)blockId;

/**
 *  Clear all information about all blockIds
 */
+ (void)clear;

@end

NS_ASSUME_NONNULL_END
