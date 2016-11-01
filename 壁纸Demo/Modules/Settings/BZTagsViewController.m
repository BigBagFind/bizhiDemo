//
//  BZTagsViewController.m
//  壁纸Demo
//
//  Created by 铁拳科技 on 16/10/14.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "BZTagsViewController.h"
#import <ReactiveCocoa.h>
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import <Objection.h>
#import "BZAPIManager.h"
#import "BZTagModel.h"
#import "Protocols.h"

static NSString *const cellIdentifier = @"cell";

@interface BZTagsViewController ()

@property (nonatomic) NSArray *tags;

@end

@implementation BZTagsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // 解决被下啦的偏移量
    // 默认被top开始，偏移44
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    @weakify(self);
    [RACObserve(self, tags) subscribeNext:^(NSArray *tags) {
        @strongify(self);
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSUInteger i = 0; i < tags.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }];
    
    // 上拉刷新
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [[[BZAPIManager sharedManager] fetchTags] subscribeNext:^(NSArray *tags) {
            self.tags = tags;
            [self.tableView.infiniteScrollingView stopAnimating];
            self.tableView.showsInfiniteScrolling = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView triggerInfiniteScrolling];
    });

    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    BZTagModel *tag = ((BZTagModel *)self.tags[indexPath.row]);
    NSString *tagName = tag.tagName;
    NSString *pinCountString = [NSString stringWithFormat:@"%ld", (long)tag.pinCount];
    NSString *displayString = [NSString stringWithFormat:@"%@ 共%@张", tagName, pinCountString];
    // 富文本添加2种字体
    NSDictionary *stringAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayString attributes:stringAttributes];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor grayColor]} range:NSMakeRange(tagName.length + 1, pinCountString.length + 2)];
    cell.textLabel.attributedText = attributedString;
    
    // 加箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 去除线的头部空隙
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    // 设置背景淡一点
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    cell.selectedBackgroundView = bgView;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController <BZWaterfallViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(BZWaterfallViewControllerProtocol)];
    NSString *tagName = ((BZTagModel *)self.tags[indexPath.row]).tagName;
    [viewController configureWithTag:tagName];
    viewController.title = tagName;
    [self.navigationController pushViewController:viewController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
