//
//  BZDetailViewCell.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 2016/10/17.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZPinModel;

@interface BZDetailViewCell : UICollectionViewCell

//
@property (nonatomic) UIScrollView *detailImageScrollView;


- (void)configureCellWithPin:(BZPinModel *)pin;




@end
