//
//  BaseTransitionAnimator.m
//  Animator2
//
//  Created by Matthew Bradshaw on 2/19/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import "BaseTransitionAnimator.h"

static NSTimeInterval const kDefaultDuration = 1.0;

@implementation BaseTransitionAnimator

-(instancetype)init {
    self = [super init];
    if (self) {
        _duration = kDefaultDuration;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
//not autocompleting check @import Foundation;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //must be implemented by inheriting class
    [self doesNotRecognizeSelector:_cmd];
}
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    return self.duration;
//}
//
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    // Must be implemented by inheriting class
//    [self doesNotRecognizeSelector:_cmd];
//}

@end
