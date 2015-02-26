//
//  SchoolController.m
//  BookExchange
//
//  Created by Folarin Williamson on 2/24/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "SchoolController.h"
#import "School.h"

@interface SchoolController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSArray *schools;
    NSMutableArray *schoolFilter;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSchools];
}

- (void)loadSchools {
    schools = [NSMutableArray new];
    schoolFilter = [NSMutableArray new];
    PFQuery *query = [School query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            School *school = objects.firstObject;
            schools = school.schools;

        } else {
            NSLog(@"%@",error);
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Datasource 

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {

    if (isFiltered == YES) {
        return schoolFilter.count;
    }else {
        return schools.count;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (isFiltered == YES) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSString *schoolString = [schoolFilter objectAtIndex:indexPath.row];
        NSArray *toks = [schoolString componentsSeparatedByString:@"|"];
        cell.textLabel.text = toks[0];
        cell.detailTextLabel.text = toks[1];
        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSString *schoolString = [schools objectAtIndex:indexPath.row];
        NSArray *toks = [schoolString componentsSeparatedByString:@"|"];
        cell.textLabel.text = toks[0];
        cell.detailTextLabel.text = toks[1];
        return cell;
    }
    return nil;
}

#pragma mark - UITableView Delegate

-(void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (isFiltered == YES) {
        NSString *schoolStr = [schoolFilter objectAtIndex:indexPath.row];
        NSArray *toks = [schoolStr componentsSeparatedByString:@"|"];
        [self.delegate schoolController:self didFinishWithName:toks[0]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSString *schoolStr = [schools objectAtIndex:indexPath.row];
        NSArray *toks = [schoolStr componentsSeparatedByString:@"|"];
        [self.delegate schoolController:self didFinishWithName:toks[0]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UISearchBar Delegate 

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (searchText.length == 0) {
        isFiltered = NO;
    } else {
        isFiltered = YES;
        schoolFilter = [NSMutableArray new];

        for (NSString *schoolString in schools) {

            NSRange nameRange  = [schoolString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {

                [schoolFilter addObject:schoolString];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
