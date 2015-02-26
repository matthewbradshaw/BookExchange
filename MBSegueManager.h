//
//  CustomSeque.h/Users/matthewbradshaw/Desktop/apps/Animator3/Animator2/MBSegueManager.h
//  Animator2
//
//  Created by Matthew Bradshaw on 2/24/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideTransitionAnimator.h"


@interface MBSegueManager : NSObject

- (instancetype)init;
- (void)registerSegueToViewController:(UIViewController *)viewController withSegueEdge:(SOLEdge)edge;
- (void)registerSegueFromViewController:(UIViewController *)viewController withSegueEdge:(SOLEdge)edge;

@end
