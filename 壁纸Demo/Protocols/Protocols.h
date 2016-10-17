//
//  Protocols.h
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

/** 瀑布流VC协议 */
@protocol BZWaterfallViewControllerProtocol <NSObject>

/** 初始化设置分类 */
- (void)configureWithTag:(NSString *)tag;

/** 初始化设置分类 */
- (void)configureWithLatest;

@end




/** 瀑布流VM协议 */
@protocol BZWaterfallViewModelProtocol <NSObject>

@property (nonatomic) NSArray *pins;


- (RACSignal *)fetchPinsWithTag:(NSString *)tag offset:(NSUInteger)offset;


- (RACSignal *)fetchMore;


@end




/** 详情VC协议 */
@protocol BZDetailViewControllerProtocol <NSObject>


@property (nonatomic) NSInteger currentPinIndex;


@property (nonatomic) NSInteger initPinIndex;

/**  配置对应viewModel */
- (void)configureWithViewModel:(id<BZWaterfallViewModelProtocol>)viewModel;



@end




/** 分类VC协议 */
@protocol  BZTagsViewControllerProtocol <NSObject>


@end




/** 设置VC协议 */
@protocol  BZSettingsViewControllerProtocol <NSObject>




@end














