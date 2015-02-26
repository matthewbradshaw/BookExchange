//
//  LoginViewController.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

+ (void)saveKey:(NSString *)key withValue:(NSString *)value;
+ (NSString *)getValueWithKey:(NSString *)key;

@end
