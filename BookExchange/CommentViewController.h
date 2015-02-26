//
//  CommentViewController.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTransaction.h"

@protocol CommentViewControllerDelegate <NSObject>

- (void)updateMessageCount;

@end

@interface CommentViewController : UIViewController

@property BookTransaction *buyTransaction;
@property BookTransaction *sellTransaction;

@property id<CommentViewControllerDelegate> delegate;


@end
