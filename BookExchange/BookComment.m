//
//  BookComment.m
//  BookExchange
//
//  Created by Folarin Williamson on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "BookComment.h"
#import "ParseEntities.h"

@implementation BookComment

@dynamic userName;
@dynamic userComment;
@dynamic buyTransactionId;
@dynamic sellTransactionId;

+ (NSString *)parseClassName {
    return kParseComment;  
}

+ (void)load {
    [self registerSubclass];
}

@end
