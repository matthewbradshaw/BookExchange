//
//  Book.h
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

#import "BookTransaction.h"

@class Book;

@interface Book : PFObject <PFSubclassing>

@property (retain) NSString *isbn10;
@property (retain) NSString *isbn13;
@property (retain) NSString *title;
@property (retain) NSArray *authors;
@property (retain) NSString *publisher;
@property (retain) NSDate *publishDate;
@property (retain) NSString *bookDescription;
@property (retain) NSNumber *pageCount;
@property (retain) NSString *thumbnail;

@property (retain) NSArray *words;

+ (Book *)populateBook:(NSDictionary *)json withScannedISBN:(NSString *)isbnScanned;

+ (NSString *)parseClassName;

@end
