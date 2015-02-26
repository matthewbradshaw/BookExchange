//
//  BounceTransitionAnimator.h
//  Animator2
//
//  Created by Matthew Bradshaw on 2/23/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import "SlideTransitionAnimator.h"

@interface BounceTransitionAnimator : SlideTransitionAnimator

@property (nonatomic, assign) CGFloat dampingRatio;
@property (nonatomic, assign) CGFloat velocity;

@end
