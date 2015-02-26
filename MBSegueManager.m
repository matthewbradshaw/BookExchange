//
//  CustomSeque.m
//  Animator2
//
//  Created by Matthew Bradshaw on 2/24/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import "MBSegueManager.h"
#import "SlideTransitionAnimator.h"
#import "BounceTransitionAnimator.h"


@interface MBSegueManager () <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property NSMutableDictionary *segueRegistryToVC;
@property NSMutableDictionary *segueRegistryFromVC;

@end


@implementation MBSegueManager

#pragma mark - UIViewControllerTransitioningDelegate

- (instancetype)init {
    self = [super init];

    self.segueRegistryToVC = [NSMutableDictionary new];
    self.segueRegistryFromVC = [NSMutableDictionary new];

    return self;
}


- (void)registerSegueToViewController:(UIViewController *)viewController withSegueEdge:(SOLEdge)edge {
    [self.segueRegistryToVC setObject:[NSNumber numberWithInt:edge] forKey:NSStringFromClass([viewController class])];
}

- (void)registerSegueFromViewController:(UIViewController *)viewController withSegueEdge:(SOLEdge)edge {
    [self.segueRegistryFromVC setObject:[NSNumber numberWithInt:edge] forKey:NSStringFromClass([viewController class])];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {

    id<UIViewControllerAnimatedTransitioning> animationController;

    BounceTransitionAnimator *animator = [[BounceTransitionAnimator alloc] init];
    animator.appearing = YES;
    animator.duration = 0.5;
    animator.dampingRatio = 0.75;
    animator.velocity =  1.00;
    animator.edge = SOLEdgeTop;  //set it anyway to check for a logic error


    animator.edge = [[self.segueRegistryToVC objectForKey:NSStringFromClass([presented class])] integerValue];

    animationController = animator;
    return animationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    id<UIViewControllerAnimatedTransitioning> animationController;

    BounceTransitionAnimator *animator = [[BounceTransitionAnimator alloc] init];
    animator.appearing = YES;
    animator.duration = 0.5;
    animator.dampingRatio = 0.75;
    animator.velocity =  1.00;


    animator.edge = [[self.segueRegistryToVC objectForKey:NSStringFromClass([dismissed class])] integerValue];

    animationController = animator;

    return animationController;
}

#pragma mark - UINavigationControllerDelegate


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    id<UIViewControllerAnimatedTransitioning> animationController;

    SlideTransitionAnimator *animator = [[SlideTransitionAnimator alloc] init];
    animator.appearing = NO;
    animator.duration = 0.3;

    if([self.segueRegistryToVC objectForKey:NSStringFromClass([fromVC class])]) {
        animator.edge = [[self.segueRegistryToVC objectForKey:NSStringFromClass([fromVC class])] integerValue];
    }

    if([self.segueRegistryFromVC objectForKey:NSStringFromClass([toVC class])]) {
        animator.edge = [[self.segueRegistryFromVC objectForKey:NSStringFromClass([toVC class])] integerValue];
    }
    
    animationController = animator;
    
    
    return animationController;
}



@end
