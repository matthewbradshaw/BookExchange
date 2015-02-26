//
//  ConvoTableHeader.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/23/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvoTableHeader : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPrice;
@property (weak, nonatomic) IBOutlet UILabel *bookCondition;

@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundView;

@end
