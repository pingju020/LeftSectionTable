//
//  LeftSectionTableView.h
//  LeftSectionTable
//
//  Created by yangjuanping on 2018/9/30.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftSectionTableView;

@protocol LeftSectionTableViewDataSource <NSObject>
@required
//表示表中的行数
- (NSInteger)tableView:(LeftSectionTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(LeftSectionTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)tableView:(LeftSectionTableView *)tableView viewForSection:(NSInteger)section;

////获取给定的单元格
//- (UIView *)cellForRow:(NSInteger)row;

@optional
//返回表格的高度
- (CGFloat)rowHeight;

- (NSInteger)numberOfSectionsInTableView:(LeftSectionTableView *)tableView;

// 表头的宽度
- (CGFloat)sectionWidth;
@end

@interface LeftSectionView : UIView
@property(nonatomic,strong)NSString* iconName;
@property(nonatomic,strong)NSString* sectionTitle;
@end

@interface LeftSectionTableView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,assign) id <LeftSectionTableViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame cellClass:(_Nonnull Class)cellClass sectionClass:(_Nonnull Class)sectionClass;

//出现一个可以重用的单元格
- (UITableViewCell *)dequeueReusableCell;

// 出现一个可以重用的section
- (UIView *)dequeueReusableSection;

//注册一个单元格的类，设置的话应该在调用init后立即调用
- (void)registerClassForCells:(Class)cellClass;

// 注册一个section的类，设置的话应该在调用init后立即调用
-(void)registerClassForSections:(Class)sectionClass;
@end



