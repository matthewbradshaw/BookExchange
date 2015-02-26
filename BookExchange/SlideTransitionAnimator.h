//
//  SlideTransitionAnimator.h
//  Animator2
//
//  Created by Matthew Bradshaw on 2/19/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//
//you might need this import
@import Foundation;
#import "BaseTransitionAnimator.h"

typedef NS_ENUM(NSInteger, SOLEdge) {
    SOLEdgeTop,
    SOLEdgeLeft,
    SOLEdgeBottom,
    SOLEdgeRight,
    SOLEdgeTopRight,
    SOLEdgeTopLeft,
    SOLEdgeBottomRight,
    SOLEdgeBottomLeft
};

@interface SlideTransitionAnimator : BaseTransitionAnimator

@property SOLEdge edge;

+ (NSDictionary *)edgeDisplayNames;

- (CGRect)rectOffsetFromRect:(CGRect)rect atEdge:(SOLEdge)edge;

@end
