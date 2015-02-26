//
//  BookCell.h
//  BookExchange
//
//  Created by Folarin Williamson on 2/21/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;

@end
