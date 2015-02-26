//
//  CommentViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "CommentViewController.h"
#import "BookComment.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fieldAddComment;
@property (strong, nonatomic) IBOutlet UITableView *tableCommentThread;

@end

@implementation CommentViewController
{
    NSMutableArray *comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    comments = [NSMutableArray new];

    PFQuery *query = [BookComment query];
    [query orderByDescending:@"createdAt"];

    [query whereKey:@"buyTransactionId" equalTo:self.buyTransaction.objectId];
    [query whereKey:@"sellTransactionId" equalTo:self.sellTransaction.objectId];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(BookComment *comment in objects) {
            [comments addObject:comment];
        }

        [self.tableCommentThread reloadData];
    }];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(NSString *)dateDiff:(NSDate *)origDate {
    NSDate *todayDate = [NSDate date];
    double ti = [origDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        if(diff > 1) {
            return [NSString stringWithFormat:@"%d minutes ago", diff];
        } else {
            return [NSString stringWithFormat:@"%d minute ago", diff];
        }
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if(diff > 1) {
            return[NSString stringWithFormat:@"%d hours ago", diff];
        } else {
            return[NSString stringWithFormat:@"%d hour ago", diff];
        }
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        if(diff > 1) {
            return[NSString stringWithFormat:@"%d days ago", diff];
        } else {
            return[NSString stringWithFormat:@"%d day ago", diff];
        }
    } else {
        return @"never";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BookComment *comment = [BookComment object];
    comment.userComment = textField.text;
    comment.userName = [PFUser currentUser].username;
    comment.buyTransactionId = self.buyTransaction.objectId;
    comment.sellTransactionId = self.sellTransaction.objectId;
    [comment saveInBackground];

    self.buyTransaction.messageCount = [NSNumber numberWithLong:(self.buyTransaction.messageCount.longValue + 1)];
    [self.buyTransaction saveInBackground];
    self.sellTransaction.messageCount = [NSNumber numberWithLong:(self.sellTransaction.messageCount.longValue + 1)];
    [self.sellTransaction saveInBackground];

    [comments insertObject:comment atIndex:0];
    [self.tableCommentThread reloadData];

    textField.text = nil;
    [textField resignFirstResponder];

    [self.delegate updateMessageCount];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];

    BookComment *comment = [comments objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = comment.userComment;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", comment.userName, [self dateDiff:comment.createdAt]];

    return cell;
}

#pragma mark - UITableView Delegate

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
