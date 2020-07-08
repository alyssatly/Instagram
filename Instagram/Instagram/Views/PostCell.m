//
//  PostCell.m
//  Instagram
//
//  Created by Alyssa Tan on 7/7/20.
//  Copyright © 2020 Alyssa Tan. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
    self.captionLabel = post[@"caption"];
}

@end
