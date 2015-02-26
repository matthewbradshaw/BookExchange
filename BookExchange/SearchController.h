//
//  SearchController.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/20/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@protocol AddBookProtocol <NSObject>

- (void) updateBoooks:(Book *)book;

@end

@interface SearchController : UIViewController

@property id<AddBookProtocol> delegate;

@end
