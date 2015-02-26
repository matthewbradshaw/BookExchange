//
//  BookOwned.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <Parse/Parse.h>

@class Book;

@interface BookTransaction : PFObject <PFSubclassing>

@property (retain) NSString *userId;
@property (retain) NSString *bookId;
@property (retain) NSString *userName;
@property (retain) NSString *modality;
@property (retain) NSNumber *messageCount;

@property (retain) NSNumber *price;
@property (retain) NSString *condition;

@property (retain) NSString *isbn10;
@property (retain) NSString *isbn13;
@property (retain) NSString *title;
@property (retain) NSArray *authors;
@property (retain) NSString *publisher;
@property (retain) NSDate *publishDate;
@property (retain) NSString *bookDescription;
@property (retain) NSNumber *pageCount;
@property (retain) NSString *thumbnail;

@property (retain) NSNumber *latitude;
@property (retain) NSNumber *longitude;

+ (NSString *)parseClassName;

+ (BookTransaction *)populateTransaction:(Book *)book withPrice:(NSNumber *)price andCondition:(NSString *)condition andModality:(NSString *)modality;

@end
