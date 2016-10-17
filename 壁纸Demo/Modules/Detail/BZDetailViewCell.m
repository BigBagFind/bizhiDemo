//
//  BZDetailViewCell.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 2016/10/17.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZDetailViewCell.h"
#import "BZPinModel.h"
#import "UIColor+LightRandom.h"
#import  <ReactiveCocoa.h>
#import "UIImageView+WebCache.h"

@interface BZDetailViewCell ()

@property (nonatomic) UIImageView *detailImageView;
@property (nonatomic) UIProgressView *progressView;

@end


@implementation BZDetailViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.detailImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.detailImageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.detailImageScrollView.alwaysBounceVertical = YES;
        self.detailImageScrollView.contentSize = [UIScreen mainScreen].bounds.size;
        [self.detailImageScrollView addSubview:self.detailImageView];
        [self.contentView addSubview:self.detailImageScrollView];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        if ([self.progressView respondsToSelector:@selector(tintColor)]) {
            self.progressView.tintColor = [UIColor grayColor];
        }
        self.progressView.trackTintColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:self.progressView];
        self.progressView.frame = CGRectMake(100, [UIScreen mainScreen].bounds.size.height / 2, 120, 2);
    }
    return self;
}


- (void)configureCellWithPin:(BZPinModel *)pin {
    @weakify(self);
    self.progressView.progress = 0;
    self.contentView.backgroundColor = [UIColor lightRandom];
    
    NSURL *imageURL = [NSURL URLWithString:[pin imageURLWithThumbnailWidth:658]];
    self.progressView.hidden = NO;
    [self.detailImageView sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}



@end
