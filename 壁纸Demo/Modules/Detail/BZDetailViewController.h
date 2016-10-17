//
//  DetailViewController.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface BZDetailViewController : UICollectionViewController <BZDetailViewControllerProtocol>

/** 当前的index */
@property (nonatomic) NSInteger currentPinIndex;

/** 弹出时初始化的index */
@property (nonatomic) NSInteger initPinIndex;




@end
