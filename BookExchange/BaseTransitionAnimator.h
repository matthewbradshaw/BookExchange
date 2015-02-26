//
//  BaseTransitionAnimator.h
//  Animator2
//
//  Created by Matthew Bradshaw on 2/19/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//@import Foundation;
//@import UIKit;
//@interface BaseTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate>

@interface BaseTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property BOOL appearing;
@property NSTimeInterval duration;

@end
