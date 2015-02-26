//
//  SellViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "SellViewController.h"
#import "ConversationViewController.h"
#import "FinalizePostViewController.h"

#import "MBSegueManager.h"

#import "Book.h"
#import "BookTransaction.h"

#define kWidthConstant 15

@interface SellViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FinalizePostViewControllerDelegate, ConversationUpdate>

@property MBSegueManager<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate> *customSegue;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionBooks;

@end

@implementation SellViewController
{
    NSMutableArray *bookTransactions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBooks:@"sell"];

    self.customSegue = (MBSegueManager<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate> *)[MBSegueManager new];
    [self.customSegue registerSegueToViewController:[ConversationViewController new] withSegueEdge:SOLEdgeRight];
    [self.customSegue registerSegueFromViewController:[ConversationViewController new] withSegueEdge:SOLEdgeLeft];

}

- (void)loadBooks:(NSString *)modality {
    PFQuery *query = [BookTransaction query];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {

            bookTransactions = [NSMutableArray new];
            [bookTransactions addObject:[BookTransaction new]];
            for(BookTransaction *transaction in objects) {
                if([transaction.modality isEqualToString:modality]) {
                    [bookTransactions addObject:transaction];
                }
            }

            [self.collectionBooks reloadData];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)sender {
    if([segue.identifier isEqualToString:@"SellSegue"]) {
        FinalizePostViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    } else {
        ConversationViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionBooks indexPathForCell:sender];
        controller.currentTransaction = [bookTransactions objectAtIndex:indexPath.row];
        controller.delegate = self;

        controller.currentTransaction = [bookTransactions objectAtIndex:indexPath.row];
        controller.delegate = self;
        controller.transitioningDelegate = self.customSegue;
        self.navigationController.delegate = self.customSegue;

    }
}

- (void)updateTransaction:(Book *)book withPrice:(NSNumber *)price andCondition:(NSString *)condition {
    // create a book transaction query
    PFQuery *query = [BookTransaction query];

    // we want to ensure there are no duplicates
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"bookId" equalTo:book.objectId];

    // perform search on BookTransaction
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            if(objects.count == 0) {
                BookTransaction *transaction = [BookTransaction populateTransaction:book withPrice:price andCondition:condition andModality:@"sell"];
                [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(error) {
                        NSLog(@"%@", error);
                    } else {
                        [bookTransactions insertObject:transaction atIndex:1];
                        [self.collectionBooks reloadData];
                    }
                }];
            }
        }
    }]; 
    
}

#pragma mark - Conversation Protocol

- (void) reloadTransactionSet:(BookTransaction *)transaction {

    [bookTransactions removeObject:transaction];
    [self.collectionBooks reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return bookTransactions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BookTransaction *transaction = [bookTransactions objectAtIndex:indexPath.row];

    if(transaction.title) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCell" forIndexPath:indexPath];

        if (transaction.thumbnail) {


        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:transaction.thumbnail]];
            if(data == nil) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
                imageView.image = [UIImage imageWithData:data];
            });
        });
        }else {
            UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
            [imageView setImage:[UIImage imageNamed:@"GrayBook"]];
            [imageView setAlpha:0.2];

            UILabel *labelTitle = (UILabel *) [cell viewWithTag:200];
            labelTitle.text = transaction.title;
            labelTitle.textColor = [UIColor whiteColor];
        }
        
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat widthPortrait = ((self.view.frame.size.width) / 3) - kWidthConstant;

    return CGSizeMake(widthPortrait, 130);
}


@end
