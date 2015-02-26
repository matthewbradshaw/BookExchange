//
//  School.m
//  BookExchange
//
//  Created by Folarin Williamson on 2/24/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "School.h"
#import "ParseEntities.h"

@implementation School

@dynamic name;
@dynamic state;
@dynamic school;
@dynamic schools;

+ (NSString *)parseClassName {
    return kParseSchools;
}

+ (void)load {
    [self registerSubclass];
}

- (NSString *)description {
    return [NSString stringWithFormat: @"[%@]\t%@",self.state, self.name];
}

@end
