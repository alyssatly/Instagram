//
//  LoginViewController.m
//  Instagram
//
//  Created by Alyssa Tan on 7/6/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *loginView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //run textfield programmatically
    
    //hide keyboard with hideKeyboard selector
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.loginView addGestureRecognizer:gestureRecognizer];
}

-(void)hideKeyboard{
    [self.usernameTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (IBAction)signupPressed:(UIButton *)sender {
    if([self.usernameTextField.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up"
               message:@"Username field is empty"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
          style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
    }else if([self.passwordTextField.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up"
               message:@"Password field is empty"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
          style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }else{
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameTextField.text;
        //newUser.email = self.emailField.text;
        newUser.password = self.passwordTextField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up"
                       message:error.localizedDescription
                preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * _Nonnull action) {
                        // handle response here.
                }];
                
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"firstSegue" sender:nil];
                // manually segue to logged in view
            }
        }];
    }
}

- (IBAction)loginPressed:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error logging in"
                   message:error.localizedDescription
            preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * _Nonnull action) {
                    // handle response here.
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
            // display view controller that needs to shown after successful login
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
