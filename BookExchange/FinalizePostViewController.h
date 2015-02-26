//
//  SaleViewController.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/23/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@protocol FinalizePostViewControllerDelegate <NSObject>

- (void)updateTransaction:(Book *)book withPrice:(NSNumber *)price andCondition:(NSString *)condition;

@end

@interface FinalizePostViewController : UIViewController

@property id<FinalizePostViewControllerDelegate>delegate;

@end
