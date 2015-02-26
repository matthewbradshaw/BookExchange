//
//  ConversationViewController.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTransaction.h"
@protocol ConversationUpdate <NSObject>

- (void) reloadTransactionSet:(BookTransaction *)transaction;

@end

@interface ConversationViewController : UIViewController

@property BookTransaction *currentTransaction;
@property id<ConversationUpdate>delegate;


@end
