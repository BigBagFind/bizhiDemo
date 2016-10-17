//
//  BZWaterfallViewCell.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/17.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <RACEXTScope.h>
#import "BZWaterfallViewCell.h"
#import "UIColor+LightRandom.h"
#import "UIImageView+WebCache.h"



@interface BZWaterfallViewCell ()

@property (nonatomic,strong) UIImageView *thumbnailImageView;

@end

@implementation BZWaterfallViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 底部ImageView
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.thumbnailImageView];
        // 头上点击按钮
        self.thumbnailImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.thumbnailImageButton.frame = self.thumbnailImageView.frame;
        [self.contentView addSubview:self.thumbnailImageButton];
    }
    return self;
}


- (void)configureWithViewModel:(BZWaterfallCellViewModel *)viewModel {
    
    self.viewModel = viewModel;
    self.backgroundColor = [UIColor lightRandom];
    
    NSURL *imageURL = [NSURL URLWithString:[viewModel.pin imageURLWithThumbnailWidth:236]];
    
    @weakify(self);
    [self.thumbnailImageView sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if (cacheType != SDImageCacheTypeMemory) {
            self.thumbnailImageView.alpha = 0.f;
            [UIView animateWithDuration:0.3 animations:^{
                self.thumbnailImageView.alpha = 1.f;
            }];
        }
    }];
    
}

























@end
