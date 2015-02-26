//
//  ProfileViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/22/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import "ProfileViewController.h"
#import "SchoolController.h"
#import "School.h"
#import "LoginViewController.h"

#import <Parse/Parse.h>

@interface ProfileViewController () <SchoolProtocol>

@property (weak, nonatomic) IBOutlet UITextField *currentUserPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmUserPassword;
@property (weak, nonatomic) IBOutlet UITextField *selectSchoolField;
@property (weak, nonatomic) IBOutlet UITextField *nPasswordField;

@end

@implementation ProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    self.selectSchoolField.text = currentUser[@"school"];
}

- (IBAction)saveChangesTapped:(UIButton *)sender {
    PFUser *user = [PFUser currentUser];
    [PFUser logInWithUsernameInBackground:user.username password:self.currentUserPassword.text block:^(PFUser *user, NSError *error) {
        if(!error) {
            user.password = self.confirmUserPassword.text;
            [user saveInBackground];
            [self reset];

        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void) reset {
    self.currentUserPassword.text = nil;
    self.nPasswordField.text = nil;
    self.confirmUserPassword.text = nil;
}

#pragma mark - Action 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SchoolSegue"]) {
        SchoolController *controller = segue.destinationViewController;
        controller.delegate = self; 
    }
}

- (IBAction)schoolSave:(UIButton *)sender {

    PFUser *user = [PFUser currentUser];
    [user setObject:self.selectSchoolField.text forKey:@"school"];
    [user saveInBackground];
}

- (IBAction)logOutTapped:(UIButton *)sender {

    [PFUser logOut];
    [PFUser currentUser].sessionToken = nil;
    [LoginViewController saveKey:@"token" withValue:nil];
}


#pragma mark - School Protocol

- (void) schoolController:(UIViewController *)controller
        didFinishWithName:(NSString *)name {

    [self.selectSchoolField setEnabled: YES];
    [self.selectSchoolField setText: name];
}
@end
