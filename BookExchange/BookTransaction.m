//
//  BookOwned.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "BookTransaction.h"
#import "ParseEntities.h"
#import "Book.h"


@implementation BookTransaction

@dynamic userId;
@dynamic bookId;
@dynamic userName;
@dynamic modality;
@dynamic messageCount;

@dynamic price;
@dynamic condition;

@dynamic isbn10;
@dynamic isbn13;
@dynamic title;
@dynamic authors;
@dynamic publisher;
@dynamic publishDate;
@dynamic bookDescription;
@dynamic pageCount;
@dynamic thumbnail;

@dynamic latitude;
@dynamic longitude;


+ (NSString *)parseClassName {
    return kParseBookTransaction;
}

+ (void)load {
    [self registerSubclass];
}


+ (BookTransaction *)populateTransaction:(Book *)book withPrice:(NSNumber *)price andCondition:(NSString *)condition andModality:(NSString *)modality {
    BookTransaction *transaction = [BookTransaction object];
    transaction.userId = [PFUser currentUser].objectId;
    transaction.bookId = book.objectId;
    transaction.userName = [PFUser currentUser].username;
    transaction.modality = modality;
    transaction.messageCount = 0;

    transaction.price = price;
    transaction.condition = condition;

    transaction.isbn10 = book.isbn10;
    transaction.isbn13 = book.isbn13;
    transaction.title = book.title;
    transaction.authors = book.authors;
    transaction.publisher = book.publisher;
    transaction.publishDate = book.publishDate;
    transaction.bookDescription = book.bookDescription;
    transaction.pageCount = book.pageCount;
    transaction.thumbnail = book.thumbnail;

    return transaction;
}

+ (NSArray *)getMatches:(BookTransaction *)target {
    NSMutableArray *matches = [NSMutableArray new];

    PFQuery *query = [BookTransaction query];
    [query whereKey:@"modality" equalTo:[BookTransaction complimentModality:target]];
    [query whereKey:@"isbn10" equalTo:target.isbn10];
    [query whereKey:@"isbn13" equalTo:target.isbn13];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error) {
                NSLog(@"%@", error);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    for(BookTransaction *transaction in objects) {
                        [matches addObject:transaction];
                    }
                });
            }
        }];
    });

    return [NSArray arrayWithArray:matches];
}

+ (NSString *)complimentModality:(BookTransaction *)transaction {
    if ([@"buy" isEqualToString:transaction.modality]) {
        return @"sell";
    } else {
        return @"buy";
    }
}

@end
