//
//  BZWaterfallCellViewModel.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/17.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "BZPinModel.h"


@interface BZWaterfallCellViewModel : RVMViewModel


@property (nonatomic) BZPinModel *pin;


@property (nonatomic) NSIndexPath *indexPath;


@end
