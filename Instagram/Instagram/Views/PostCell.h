//
//  PostCell.h
//  Instagram
//
//  Created by Alyssa Tan on 7/7/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;

@end

NS_ASSUME_NONNULL_END
