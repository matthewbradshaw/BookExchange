//
//  BuyIntermediaryViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "BuyIntermediaryViewController.h"
#import "BarCodeScanViewController.h"
#import "SearchController.h"
#import "Book.h"

@interface BuyIntermediaryViewController () <ScanProtocol, AddBookProtocol>

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation BuyIntermediaryViewController
{
    BOOL dismissView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *blankView = [self.view viewWithTag:100];
    [blankView setHidden:YES];
    self.scanButton.layer.cornerRadius = 30.0f;
    self.searchButton.layer.cornerRadius = 30.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(dismissView) {
        [[self navigationController] popViewControllerAnimated:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BarCodeScanViewController *controller = segue.destinationViewController;
    controller.delegate = self;
    dismissView = YES;
    UIView *blankView = [self.view viewWithTag:100];
    [blankView setHidden:NO];
}


- (void)updateScanner:(NSString *)isbn {

    [self.buyViewController updateScanner:isbn];
}

- (void)updateBoooks:(Book *)book {
    [self.buyViewController updateBoooks:book];
}

@end
