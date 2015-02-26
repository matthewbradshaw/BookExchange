//
//  ConversationViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "ConversationViewController.h"
#import "CommentViewController.h"
#import "ConvoTableHeader.h"
#import "ConvoCell.h"

@interface ConversationViewController () <UITableViewDataSource, UITableViewDelegate, CommentViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableConversations;

@end

@implementation ConversationViewController
{
    NSArray *conversations;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConversations];
}

- (void)loadConversations {
    PFQuery *query = [BookTransaction query];
    [query whereKey:@"isbn10" equalTo:self.currentTransaction.isbn10];
    [query whereKey:@"isbn13" equalTo:self.currentTransaction.isbn13];
    [query whereKey:@"modality" equalTo:[self getModality]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSMutableArray *array = [NSMutableArray new];
            for (BookTransaction *tr in objects) {
                [array addObject:tr];
            }

            conversations = [NSArray arrayWithArray:array];
            [self.tableConversations reloadData];
        }
    }];

}

- (NSString *)getModality {
    if([self.currentTransaction.modality isEqualToString:@"buy"]) {
        return @"sell";
    } else {
        return @"buy";
    }
}

- (void)updateMessageCount {
    [self.tableConversations reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentViewController *controller = segue.destinationViewController;
    if([self.currentTransaction.modality isEqualToString:@"buy"]) {
        controller.buyTransaction = self.currentTransaction;
        controller.sellTransaction = [conversations objectAtIndex:self.tableConversations.indexPathForSelectedRow.row];
    } else {
        controller.buyTransaction = [conversations objectAtIndex:self.tableConversations.indexPathForSelectedRow.row];
        controller.sellTransaction = self.currentTransaction;
    }

    controller.delegate = self;
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheCell" forIndexPath:indexPath];

    NSString *side = @"BUYER";

    BookTransaction *transaction = [conversations objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = transaction.title;


    cell.detailTextLabel.textColor = [UIColor whiteColor];

    if([self.currentTransaction.modality isEqualToString:@"buy"]) {
        side = @"SELLER";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@ - %@: %@ [%li msgs]", transaction.price, side, transaction.userName, (long)[transaction.messageCount integerValue]];

    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@ [%li msgs]", side, transaction.userName, (long)[transaction.messageCount integerValue]];
    }

//    ConvoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TheCell" forIndexPath:indexPath];
//
    return cell;
}

#pragma mark - UITableView Delegate 

- (CGFloat) tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 150.0;
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    ConvoTableHeader *header = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];

//    BookTransaction *transaction = [conversations objectAtIndex: self.indexSelection.row];
    header.bookTitle.text = self.currentTransaction.title;
    header.bookAuthor.text = self.currentTransaction.authors.firstObject;
    if(self.currentTransaction.price) {
        header.bookPrice.text = [NSString stringWithFormat:@"$%@",self.currentTransaction.price];
        header.bookCondition.text = self.currentTransaction.condition;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.currentTransaction.thumbnail]];
        if(data == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            header.bookImageView.image = [UIImage imageWithData: data];
        });
    });

    return header;
}

#pragma mark - Action

- (IBAction)deleteTapped:(UIButton *)sender {

    [self.currentTransaction deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {

            [self.delegate reloadTransactionSet:self.currentTransaction];
            [self.navigationController popToRootViewControllerAnimated: YES];
        }
    }];

}

@end
