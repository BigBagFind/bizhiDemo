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
#import "SVProgressHUD.h"


#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height


@interface BZDetailViewController () <UIGestureRecognizerDelegate>


@property (nonatomic,strong) id <BZWaterfallViewModelProtocol> viewModel;


/** 弹出的视图 */
@property (nonatomic) UIView *actionButtonsContainerView;

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


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[BZDetailViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.actionButtonsContainerView];
    
    
    // 监听scrollViewDelegate
    @weakify(self);
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
         UIScrollView *scrollView = tuple.first;
        NSLog(@"x:%lf",scrollView.contentOffset.x);
        NSLog(@"width:%lf",scrollView.contentSize.width);
        
        // 如果滑动超过当前的内容，
        // 则加载更多
         if (scrollView.isDragging && scrollView.contentSize.width <= (scrollView.contentOffset.x + scrollView.width)) {
            
            [[self.viewModel fetchMore] subscribeNext:^(NSArray *pins) {
                if (!pins.count) {
                    [SVProgressHUD showErrorWithStatus:@"没有更多了"];
                } else {
                    NSMutableArray *mutablePins = [NSMutableArray arrayWithArray:self.viewModel.pins];
                    [mutablePins addObjectsFromArray:pins];
                    self.viewModel.pins = [mutablePins copy];
                }
            }];
            
        }
    }];
    
    
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        // 监听当前页面
        UIScrollView *scrollView = tuple.first;
        self.currentPinIndex = scrollView.contentOffset.x / [[UIScreen mainScreen] bounds].size.width;
    }];

    self.collectionView.delegate = nil;
    self.collectionView.delegate = self;
    
    // 观察自己的pins
    [RACObserve(self, viewModel.pins) subscribeNext:^(NSArray *pins) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * self.initPinIndex, 0)];
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
    // 配置viewModel
    [cell configureCellWithPin:self.viewModel.pins[indexPath.row]];
    // 添加下啦手势
    [self addSwipeGestureToCell:cell];
    [self addTouchGestureToCell:cell];
    
   
    return cell;
}



#pragma mark - Utils

- (void)addGesture:(UIGestureRecognizer *)gesture ToCell:(BZDetailViewCell *)cell {
    // 公用添加手势方法
    __block UIGestureRecognizer *theGesture = gesture;
    // 移除原有手势
    [cell.detailImageScrollView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[gesture class]]) {
            [cell.detailImageScrollView removeGestureRecognizer:obj];
        }
    }];
    [cell.detailImageScrollView addGestureRecognizer: theGesture];
    // 关键在这一行，如果pan手势失败，则改为单手势
    [cell.detailImageScrollView.panGestureRecognizer requireGestureRecognizerToFail:theGesture];
}

- (void)addSwipeGestureToCell:(BZDetailViewCell *)cell {
    // 添加向下滑动手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] init];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipeGesture.delegate = self;
    [self addGesture:swipeGesture ToCell:cell];
    @weakify(self);
    [[swipeGesture.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UISwipeGestureRecognizer *gesture) {
        @strongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)addTouchGestureToCell:(BZDetailViewCell *)cell {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self addGesture:tapGesture ToCell:cell];
    
    @weakify(self);
    [[tapGesture.rac_gestureSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        if (self.actionButtonsContainerView.hidden) {
            self.actionButtonsContainerView.alpha = 0;
            self.actionButtonsContainerView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.actionButtonsContainerView.alpha = 1;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.actionButtonsContainerView.alpha = 0;
            } completion:^(BOOL finished) {
                self.actionButtonsContainerView.hidden = YES;
            }];
        }
    }];
}



#pragma mark - Accessors

- (UIView *)actionButtonsContainerView {
    if (!_actionButtonsContainerView) {
        UIImage *shareButtonImage = [UIImage imageNamed:@"button_share"];
        CGSize containerSize = CGSizeMake(shareButtonImage.size.width + 20, shareButtonImage.size.height + 20);
        _actionButtonsContainerView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - containerSize.width) / 2, ScreenHeight - containerSize.height - 20, containerSize.width, containerSize.height)];
        _actionButtonsContainerView.layer.cornerRadius = 6;
        _actionButtonsContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
        shareButton.frame = CGRectMake(10, 10,shareButtonImage.size.width , shareButtonImage.size.height);
        [_actionButtonsContainerView addSubview:shareButton];
        
        @weakify(self);
        //        shareButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //            @strongify(self);
        //            BZPinModel *currentPin = (BZPinModel *)self.viewModel.pins[self.currentPinIndex];
        //            NSString *URLString = [currentPin imageURLWithThumbnailWidth:658];
        //            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //                if (![[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:URLString]]) {
        //                    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
        //                }
        //                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:URLString]
        //                                                                options:SDWebImageRetryFailed
        //                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //                                                               } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //                                                                   [SVProgressHUD dismiss];
        //                                                                   [subscriber sendCompleted];
        //                                                                   if (!error) {
        //                                                                       @strongify(self);
        //                                                                       [self shareWithImage:image];
        //                                                                   }
        //                                                               }];
        //                return nil;
        //            }];
        //        }];
    }
    return _actionButtonsContainerView;
}


@end
