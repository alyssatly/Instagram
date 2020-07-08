//
//  DetailsViewController.m
//  Instagram
//
//  Created by Alyssa Tan on 7/8/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import <Parse/Parse.h>
@import Parse;

@interface DetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionLabel.text = self.post.caption;
    self.postImageView.file = self.post.image;
    self.timeLabel.text = [self.post.createdAt timeAgoSinceNow];
    self.usernameLabel.text = self.post.author.username;
    NSLog(@"%@",self.post.author);
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
