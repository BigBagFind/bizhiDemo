//
//  DetailViewController.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "BZDetailViewController.h"
#import "UIView+Layout.h"
#import "BZDetailViewCell.h"


@interface BZDetailViewController ()


@property (nonatomic,strong) id <BZWaterfallViewModelProtocol> viewModel;


@end



@implementation BZDetailViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    // initCollectionLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithCollectionViewLayout:layout];
    
    // initViewModel
    if (self) {
        // 初始化当前index
        RAC(self,currentPinIndex) = RACObserve(self, initPinIndex);
    }
    return self;
}


- (void)configureWithViewModel:(id<BZWaterfallViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[BZDetailViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled = YES;

}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.pins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BZDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell configureCellWithPin:self.viewModel.pins[indexPath.row]];
    
    
    return cell;
}


@end
