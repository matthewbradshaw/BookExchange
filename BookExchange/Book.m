//
//  Book.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "Book.h"
#import "ParseEntities.h" 

@implementation Book

@dynamic isbn10;
@dynamic isbn13;
@dynamic title;
@dynamic authors;
@dynamic publisher;
@dynamic publishDate;
@dynamic bookDescription;
@dynamic pageCount;
@dynamic thumbnail;

@dynamic words;

+ (NSString *)parseClassName {
    return kParseBooks;
}

+ (void)load {
    [self registerSubclass];
}

+ (Book *)populateBook:(NSDictionary *)json withScannedISBN:(NSString *)isbnScanned{
    Book *book = [Book object];

    NSDictionary *entry = ((NSArray *) json[@"items"]).firstObject;

    NSDictionary *volumeInfo = entry[@"volumeInfo"];

    book.title = volumeInfo[@"title"];
    book.publisher = volumeInfo[@"publisher"];
    book.publishDate = volumeInfo[@"publishDate"];
    book.bookDescription = volumeInfo[@"description"];


    NSArray *isbn = volumeInfo[@"industryIdentifiers"];
    for(NSDictionary *dict in isbn) {
        NSString *targetIsbn = [dict objectForKey:@"identifier"];
        if(targetIsbn.length == 10) {
            book.isbn10 = targetIsbn;
        } else if(targetIsbn.length == 13) {
            book.isbn13 = targetIsbn;
        }
    }

    if(!book.isbn10 || !book.isbn13) {
        book.isbn10 = isbnScanned;
        book.isbn13 = isbnScanned;
    }

    book.authors = volumeInfo[@"authors"];

    NSDictionary *imageLinks = volumeInfo[@"imageLinks"];
    book.thumbnail = imageLinks[@"thumbnail"];

    book.pageCount = volumeInfo[@"pageCount"];

    return book;
}

@end
