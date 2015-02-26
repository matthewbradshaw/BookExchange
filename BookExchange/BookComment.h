//
//  BookComment.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface BookComment : PFObject <PFSubclassing>

@property NSString *userName;
@property NSString *userComment;
@property NSString *buyTransactionId;
@property NSString *sellTransactionId;

+ (NSString *) parseClassName; 

@end
