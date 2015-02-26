//
//  SaleViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/23/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "FinalizePostViewController.h"
#import "BarCodeScanViewController.h"


@interface FinalizePostViewController () <ScanProtocol>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewCover;

@property (strong, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (strong, nonatomic) IBOutlet UITextField *fieldPrice;
@property (strong, nonatomic) IBOutlet UITextField *fieldCondition;

@property Book *currentBook;

@end

@implementation FinalizePostViewController
{
    BOOL forwardedToScan;
    BOOL scanExists;

    IBOutlet UIView *coverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if(!forwardedToScan) {
        forwardedToScan = YES;
        [self performSegueWithIdentifier:@"ScanSegue" sender:self];
    } else if(!scanExists) {
        [[self navigationController] popViewControllerAnimated:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BarCodeScanViewController *controller = segue.destinationViewController;
    controller.delegate = self;
    forwardedToScan = YES;
}

#pragma mark - ScanProtocol

// protocol method that gets called when a barcode is recognized
- (void)updateScanner:(NSString *)isbn {
    scanExists = YES;
    forwardedToScan = YES;
    [coverView setHidden:YES];

    // prepare the Google API url with the isbn
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@", isbn];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    // make request to Google API
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // parse the response from Google API into NSDictionary object
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

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

- (void)updateTransaction:(Book *)book {
    self.currentBook = book;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.currentBook.thumbnail]];
        if(data == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageViewCover.image = [UIImage imageWithData:data];
        });
    });
}

- (IBAction)tapFinalizePost:(UIButton *)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *price = [f numberFromString:self.fieldPrice.text];
    [self.delegate updateTransaction:self.currentBook withPrice:price andCondition:self.fieldCondition.text];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
