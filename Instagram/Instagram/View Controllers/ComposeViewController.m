//
//  ComposeViewController.m
//  Instagram
//
//  Created by Alyssa Tan on 7/7/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import "ComposeViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"
//#import "UITapGest"


@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet UITextField *captionTextField;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.instructionLabel.text = @"Tap to select image";
    self.photoImageView.image = nil;
    self.captionTextField.text = @"";
    //can tap image
    self.photoImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];

    tapGesture1.numberOfTapsRequired = 1;

    [tapGesture1 setDelegate:self];

    [self.photoImageView addGestureRecognizer:tapGesture1];
 
    //[tapGesture1 release];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void) tapGesture: (id)sender
{
    NSLog(@"Tapped!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    //[self imagePickerControllerDidCancel:<#(nonnull UIImagePickerController *)#>]
    //handle Tap...
 }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.photoImageView.image = editedImage;//[self resizeImage:editedImage withSize:<#(CGSize)#>]
    self.instructionLabel.text  = @"";
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

//use to resize your image
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)sharePressed:(id)sender {
    //post
//    Post *newPost = [Post new];
//    [newPost postUserImage];
    if(self.photoImageView.image == nil){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error posting"
               message:@"Please add a picture"
        preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
          style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else{
        //[self resizeImage:self.photoImageView.image withSize: CGSizeMake(400, 400)]
        [Post postUserImage:self.photoImageView.image withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Something went wrong");
            }else{
                NSLog(@"Post was successful!");
            }
        }];
        //try to update feed?
        
        [self dismissViewControllerAnimated:true completion:nil];
    }
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
