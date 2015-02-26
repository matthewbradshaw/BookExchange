//
//  LoginViewController.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "MBSegueManager.h"
#import "MainTabBarController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentSelect;
@property (strong, nonatomic) IBOutlet UIButton *buttonContinue;
@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *fieldConfirm;

@property MBSegueManager<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate> *customSegue; 
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // check if token exists

    NSString *sessionToken = [LoginViewController getValueWithKey:@"token"];
    if (sessionToken) {
        [PFUser becomeInBackground:sessionToken block:^(PFUser *user, NSError *error) {
            if(error) {
                NSLog(@"%@", error);
            } else {
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
            }
        }];
    } else {
        
    self.fieldConfirm.hidden = YES;
    
    self.customSegue = (MBSegueManager<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate> *)[MBSegueManager new];

    [self.customSegue registerSegueToViewController:[MainTabBarController new] withSegueEdge:SOLEdgeBottomRight];
    }

    if(self.segmentSelect.selectedSegmentIndex == 0) {
        self.fieldConfirm.hidden = YES;
        self.fieldPassword.delegate = self;
    } else {
        self.fieldConfirm.hidden = NO;
        self.fieldConfirm.delegate = self;
    }

}

- (IBAction)tapSegmentSignIn:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0) {
        self.fieldConfirm.hidden = YES;
        self.fieldPassword.delegate = self;
    } else {
        self.fieldConfirm.hidden = NO;
        self.fieldConfirm.delegate = self;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {


    [self loginUser];
    return [self resignFirstResponder];

}

- (IBAction)tapButtonContinue:(UIButton *)sender {
    [self loginUser];
}

- (void)loginUser {
    if(self.fieldConfirm.hidden) {
        [PFUser logInWithUsernameInBackground:self.fieldName.text password:self.fieldPassword.text block:^(PFUser *user, NSError *error) {
            if(!error) {
                NSString *token = @"token";
                [LoginViewController saveKey: token withValue:[PFUser currentUser].sessionToken];
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
            } else {
                NSLog(@"%@", error);
            }
        }];
    } else {
        if([self.fieldPassword.text isEqualToString:self.fieldConfirm.text]) {
            PFUser *newUser = [PFUser user];
            newUser.username = self.fieldName.text;
            newUser.password = self.fieldPassword.text;

            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSString *token = @"token";
                    [LoginViewController saveKey: token withValue:[PFUser currentUser].sessionToken];
                    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
                }
                else {
                    NSLog(@"%@", error);
                }
            }];
        }
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    MainTabBarController *controller = segue.destinationViewController;

    controller.transitioningDelegate = self.customSegue;
    self.navigationController.delegate = self.customSegue;
}

+ (void)saveKey:(NSString *)key withValue:(NSString *)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:[key lowercaseString]];
    [defaults synchronize];
}

+ (NSString *)getValueWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[key lowercaseString]];
}

@end
