//
//  BuyViewController.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchController.h"

@interface BuyViewController : UIViewController

- (void)updateScanner:(NSString *)isbn;
- (void)updateBoooks:(Book *)book;

@end
