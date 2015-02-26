//
//  ViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "RootViewController.h"
#import "BarCodeScanViewController.h"

#import "Book.h"
#import "BookTransaction.h"
#import "BookCell.h"
#import "BookDetailController.h"
#import "SearchController.h"

@interface RootViewController () <UICollectionViewDelegate, UICollectionViewDataSource,
ScanProtocol, AddBookProtocol, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *bookCollection;
@property UIButton *forSaleButton;
@property UIButton *shoppingCartButton;
@property UISegmentedControl *mySegmentedControl;

@end

@implementation RootViewController
{
    NSMutableArray *buy;
    NSMutableArray *sell;

    NSString *currentMode;

    BookTransaction *tempTransaction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBooks];


    currentMode = @"sell";
}

- (void)loadBooks {
    PFQuery *query = [BookTransaction query];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {

            buy = [NSMutableArray new];
            sell = [NSMutableArray new];

            for(BookTransaction *transaction in objects) {
                [[self getModeArray:transaction.modality] addObject:transaction];
            }

            [self.bookCollection reloadData];
        }
    }];
}

- (NSMutableArray *)getModeArray:(NSString *)modality {
    if([@"sell" isEqualToString:modality]) {
        return sell;
    } else {
        return buy;
    }
}

- (NSMutableArray *)currentModeArray {
    return [self getModeArray:currentMode];
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ScanSegue"]) {
        BarCodeScanViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"MatchSegue"]) {
        BookDetailController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = self.bookCollection.indexPathsForSelectedItems.firstObject;
        controller.bookTransaction = [[self currentModeArray] objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString: @"SearchSegue"]){
        SearchController *controller = segue.destinationViewController;
        controller.delegate = self;
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
//                BookTransaction *transaction = [BookTransaction populateTransaction:book andModality:currentMode];
//                [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if(error) {
//                        NSLog(@"%@", error);
//                    } else {
//                        [[self currentModeArray] addObject:transaction];
//                        [self.bookCollection reloadData];
//                    }
//                }];
            }
        }
    }];

}

#pragma mark - UICollectionView Datasource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self currentModeArray].count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];

    NSArray *currentBookSet = [self currentModeArray];
    BookTransaction *transaction = [currentBookSet objectAtIndex:indexPath.row];
    cell.bookTitle.text = transaction.title;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:transaction.thumbnail]];
        if(data == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.bookImageView.image = [UIImage imageWithData:data];
        });
    });

    return cell;
}

#pragma mark - Segmented Control

- (IBAction)tapSegment:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        currentMode = @"buy";
    }else {
        currentMode = @"sell";
    }

    [self.bookCollection reloadData];
}

#pragma mark - UITableView Methods

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat) tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

@end
