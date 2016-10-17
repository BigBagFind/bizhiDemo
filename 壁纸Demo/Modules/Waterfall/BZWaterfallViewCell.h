//
//  BZWaterfallViewCell.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/17.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZWaterfallCellViewModel.h"

@interface BZWaterfallViewCell : UICollectionViewCell




/** 缩略图 */
@property (nonatomic,strong) UIButton *thumbnailImageButton;

/** viewModel */
@property (nonatomic,strong) BZWaterfallCellViewModel *viewModel;

/** 配置cell对应的viewModel */
- (void)configureWithViewModel:(BZWaterfallCellViewModel *)viewModel;




@end
