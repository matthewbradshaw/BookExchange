//
//  SearchController.m
//  BookExchange
//
//  Created by Folarin Williamson on 2/20/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "SearchController.h"
#import "BookTransaction.h"
#import "Book.h"

@interface SearchController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray *searchResults;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITableView Datasource

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    Book *book = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = book.title;
    return cell;
}

- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearch Bar Delegate 

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch:[searchBar.text lowercaseString]];
}

- (void) performSearch:(NSString *)input
{
    PFQuery *query = [Book query];

    [query whereKey:@"words" containedIn:[[input lowercaseString] componentsSeparatedByString: @" "]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else
        {
            NSMutableArray *array = [NSMutableArray new];
            for (Book *book in objects) {
                [array addObject:book];
            }

            self.searchResults = [NSArray arrayWithArray:array];

            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate 

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book *book = [self.searchResults objectAtIndex:indexPath.row];
    [self.delegate updateBoooks:book];

    [[self navigationController] popViewControllerAnimated:NO];
}

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
