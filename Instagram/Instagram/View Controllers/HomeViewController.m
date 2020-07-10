//
//  HomeViewController.m
//  Instagram
//
//  Created by Alyssa Tan on 7/6/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"




@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int postLimit;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    self.postLimit = 20;
    // Do any additional setup after loading the view.
    [self getPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView insertSubview:self.refreshControl atIndex:0];
    [self.homeTableView addSubview:self.refreshControl];
    
    
}

-(void)getPosts {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = self.postLimit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            
            self.posts = (NSMutableArray *)posts;
            NSLog(@"Successfully retrieved posts%@" , self.posts);
            self.isMoreDataLoading = false;
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.homeTableView reloadData];
    }];
    
}

- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"There was a problem logging out");
        }else{
            NSLog(@"Successfully logged out!");
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

//-(void)didPost:(Post *)post {
//    [self.posts addObject:post];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqual:@"detailPost"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.homeTableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        DetailsViewController *detailViewController = (DetailsViewController *)[segue destinationViewController];
        detailViewController.post = post;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *instaPost = self.posts[indexPath.row];
    
    cell.post = instaPost;
    //cell.captionLabel.text = instaPost[@"caption"];
    //cell.postImageView.image = nil;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.homeTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.homeTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.homeTableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // ... Code to load more results ...
            if(self.posts.count == self.postLimit){
                self.postLimit += 10;
                [self getPosts];
            }
            
        }

    }
}

//-(void)loadMoreData{
//
//
//}


/*
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    <#code#>
}

- (void)setNeedsFocusUpdate {
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    <#code#>
}

- (void)updateFocusIfNeeded {
    <#code#>
}
*/
@end
