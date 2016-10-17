//
//  BZWaterfallViewController.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import <Objection.h>
#import "BZWaterfallViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "BZWaterfallViewModel.h"
#import "BZWaterfallCellViewModel.h"
#import "BZWaterfallViewCell.h"
#import "UIView+SuperView.h"


static NSString * const reuseIdentifier = @"Cell";


@interface BZWaterfallViewController ()<CHTCollectionViewDelegateWaterfallLayout>

/** ViewModel */
@property (nonatomic, strong) BZWaterfallViewModel *viewModel;

/** 缩略图command */
@property (nonatomic, strong) RACCommand *thumbnailImageButtonCommand;

/** 当前选中的selected */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation BZWaterfallViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    // initCollectionLayout
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithCollectionViewLayout:layout];
    
    // initViewModel
    if (self) {
        self.viewModel = [[BZWaterfallViewModel alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)configureWithTag:(NSString *)tag {
    self.viewModel.tag = tag;
}

- (void)configureWithLatest {
    self.viewModel.tag = @"";
}

#pragma mark - thumbnailCommand

- (RACCommand *)thumbnailImageButtonCommand {
    
    if (!_thumbnailImageButtonCommand) {
        
        @weakify(self);
        _thumbnailImageButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
            // 先找出父cell
            BZWaterfallViewCell *cell = (BZWaterfallViewCell *)[button findSuperViewWithClass:[BZWaterfallViewCell class]];
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                // 通过协议找出detailVC
                UIViewController <BZDetailViewControllerProtocol>* viewController = [[JSObjection defaultInjector] getObject:@protocol(BZDetailViewControllerProtocol)];
                // 传入点击的index
                viewController.initPinIndex = cell.viewModel.indexPath.row;
                // 初始化ViewModel
                [viewController configureWithViewModel:self.viewModel];
                
                [self presentViewController:viewController animated:YES completion:^{
                    [subscriber sendCompleted];
                }];
                // skip 1，跳过第一次默认的next
                [[RACObserve(viewController, currentPinIndex) skip:1] subscribeNext:^(id x) {
                    self.selectedIndexPath = [NSIndexPath indexPathForRow:[x intValue] inSection:0];
                }];
                return nil;
            }];
        }];
    }
    
    return _thumbnailImageButtonCommand;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[BZWaterfallViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    // 观察ViewModel的pins
    @weakify(self);
    [RACObserve(self, viewModel.pins) subscribeNext:^(NSArray *pins) {
        @strongify(self);
        NSLog(@"reloadData：%@",pins);
        [self.collectionView reloadData];
    }];
    
    
    // 下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:refreshControl];
    [[refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        [[self.viewModel fetchPinsWithTag:self.viewModel.tag offset:0] subscribeNext:^(NSArray *pins) {
            self.viewModel.pins = pins;
            [refreshControl endRefreshing];
        }];
        
    }];
    
    
    // 上拉刷新
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[self.viewModel fetchMore] subscribeNext:^(NSArray *pins) {
            if (!pins.count) {
                [SVProgressHUD showErrorWithStatus:@"没有更多了"];
            } else {
                // 原先的pins
                NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.viewModel.pins];
                // 现在加载的pins
                [mutablePins addObjectsFromArray:pins];
                // 给到viewModel
                self.viewModel.pins = [mutablePins copy];
            }
            [self.collectionView.infiniteScrollingView stopAnimating];
        }];
    }];

    // 一进去就上拉刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView triggerInfiniteScrolling];
    });
}




// http://api.huaban.com/fm/wallpaper/pins?limit=21
// http://api.huaban.com/fm/wallpaper/pins?limit=21&max=14565535
// http://api.huaban.com/fm/wallpaper/pins?limit=21&max=14565514

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.pins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BZWaterfallViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    BZWaterfallCellViewModel *viewModel = [[BZWaterfallCellViewModel alloc] init];
    viewModel.pin = self.viewModel.pins[indexPath.row];
    viewModel.indexPath = indexPath;
    
    // Configure the cell
    [cell configureWithViewModel:viewModel];
    
    cell.thumbnailImageButton.rac_command = self.thumbnailImageButtonCommand;
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(97, 145);
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
