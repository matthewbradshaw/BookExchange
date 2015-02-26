//
//  School.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/24/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface School : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *state;
@property (retain) NSString *school;
@property (retain) NSArray *schools;

@end
