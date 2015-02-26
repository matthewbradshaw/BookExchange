//
//  SchoolController.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/24/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SchoolProtocol <NSObject>

- (void) schoolController:(UIViewController *)controller didFinishWithName:(NSString *)name;

@end

@interface SchoolController : UIViewController

@property id<SchoolProtocol> delegate;


@end
