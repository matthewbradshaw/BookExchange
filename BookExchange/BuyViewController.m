//
//  SellViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "BuyViewController.h"
#import "ConversationViewController.h"
#import "BarCodeScanViewController.h"
#import "BuyIntermediaryViewController.h"
#import "MBSegueManager.h"

#import "Book.h"
#import "BookTransaction.h"

#define kWidthConstant 15

@interface BuyViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ScanProtocol, AddBookProtocol, ConversationUpdate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionBooks;

@property MBSegueManager<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate> *customSegue;


@end

@implementation BuyViewController
{
    NSMutableArray *bookTransactions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBooks:@"buy"];

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
    if([segue.identifier isEqualToString:@"AddSegue"]) {
        BuyIntermediaryViewController *controller = segue.destinationViewController;
        controller.buyViewController = self;
    } else {
        ConversationViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionBooks indexPathForCell:sender];

        controller.currentTransaction = [bookTransactions objectAtIndex:indexPath.row];
        controller.delegate = self;
        controller.transitioningDelegate = self.customSegue;
        self.navigationController.delegate = self.customSegue;
    }

}

#pragma mark - ScanProtocol

// protocol method that gets called when a barcode is recognized
- (void)updateScanner:(NSString *)isbn {
    // prepare the Google API url with the isbn
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@", isbn];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    // make request to Google API
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // parse the response from Google API into NSDictionary object
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&connectionError];


        // populate the Book object from json data (nothing saved to Parse yet)
        __block Book *book = [Book populateBook:json withScannedISBN:isbn];
        // create a query for the Book object to make ensure data is not duplicated
        PFQuery *bookQuery = [Book query];
        // set the query for isbn10/isbn13
        [bookQuery whereKey:@"isbn10" equalTo:book.isbn10];
        [bookQuery whereKey:@"isbn13" equalTo:book.isbn13];

        // execute the query
        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error) {
                NSLog(@"%@", error);
            } else if(objects.count == 1) {
                // a Book object has been found!
                book = (Book *)objects.firstObject;
                // create a transaction for this user
                [self updateTransaction:book];
            } else {
                // book object was not found, therefore -- save the new book!
                [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(error) {
                        NSLog(@"%@", error);
                    } else {
                        // now that the book has been saved, create a transaction for this user
                        [self updateTransaction:book];
                    }
                }];
            }
        }];

    }];
}

#pragma mark - Search Protocol

- (void) updateBoooks:(Book *)book
{
    [self updateTransaction:book];
}

- (void)updateTransaction:(Book *)book {
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
                BookTransaction *transaction = [BookTransaction populateTransaction:book withPrice:nil andCondition:nil andModality:@"buy"];
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return bookTransactions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BookTransaction *transaction = [bookTransactions objectAtIndex:indexPath.row];

    if(transaction.title) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCell" forIndexPath:indexPath];

        if(transaction.thumbnail) {
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
        } else {
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
