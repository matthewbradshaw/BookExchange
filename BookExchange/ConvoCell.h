//
//  ConvoCell.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/24/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
