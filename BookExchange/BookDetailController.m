//
//  BookDetailController.m
//  BookExchange
//
//  Created by Folarin Williamson on 2/21/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "BookDetailController.h"
#import "CommentViewController.h"

@interface BookDetailController () <UITableViewDataSource, UITableViewDelegate, CommentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UILabel *bookDescription;

@property (strong, nonatomic) IBOutlet UITableView *tableTransactions;

@end

@implementation BookDetailController
{
    NSArray *bookTransactions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.bookTitle.text = self.bookTransaction.title;
    self.bookAuthors.text = self.bookTransaction.authors.firstObject;
    self.bookDescription.text = self.bookTransaction.description;


    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.bookTransaction.thumbnail]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bookImageView.image = [UIImage imageWithData: data];
        });
    });

    [self matchInterest];
}

- (void)matchInterest {
    PFQuery *query = [BookTransaction query];
    [query whereKey:@"isbn10" equalTo:self.bookTransaction.isbn10];
    [query whereKey:@"isbn13" equalTo:self.bookTransaction.isbn13];
    [query whereKey:@"modality" equalTo:[self getModality]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSMutableArray *array = [NSMutableArray new];
            for (BookTransaction *tr in objects) {
                [array addObject:tr];
            }

            bookTransactions = [NSArray arrayWithArray:array];
            [self.tableTransactions reloadData];
        }
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentViewController *controller = segue.destinationViewController;
    if([self.bookTransaction.modality isEqualToString:@"buy"]) {
        controller.buyTransaction = self.bookTransaction;
        controller.sellTransaction = [bookTransactions objectAtIndex:self.tableTransactions.indexPathForSelectedRow.row];
    } else {
        controller.buyTransaction = [bookTransactions objectAtIndex:self.tableTransactions.indexPathForSelectedRow.row];
        controller.sellTransaction = self.bookTransaction;
    }

    controller.delegate = self;
}

- (void)updateMessageCount {
    BookTransaction *current = [bookTransactions objectAtIndex:self.tableTransactions.indexPathForSelectedRow.row];
    NSLog(@"%@", current.messageCount);
    [self.tableTransactions reloadData];
}

- (NSString *)getModality {
    if([self.bookTransaction.modality isEqualToString:@"buy"]) {
        return @"sell";
    } else {
        return @"buy";
    }
}

#pragma mark - UITableView Datasource 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bookTransactions.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];

    BookTransaction *transaction = [bookTransactions objectAtIndex:indexPath.row];

    cell.textLabel.text = transaction.title;
    if(!transaction.messageCount) {
        transaction.messageCount = 0;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ [%@]", transaction.userName, transaction.messageCount];
    
    return cell;
}

#pragma mark - Action

- (IBAction)exitButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}


@end
