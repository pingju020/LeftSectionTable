//
//  LeftSectionTableView.m
//  LeftSectionTable
//
//  Created by yangjuanping on 2018/9/30.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "LeftSectionTableView.h"
#import "LeftSectionTableViewCell.h"

@interface LeftSectionTableView()
@property(nonatomic,assign)NSInteger numberSections;
@property(nonatomic,strong)NSMutableArray* numberRowsNum;
@end

@implementation LeftSectionTableView{
    //可复用的一组单元格
    NSMutableSet * _reuseCells;
    //表示单元格类型的类
    Class _cellClass;
    
    NSMutableSet * _reuseSections;
    Class _sectionClass;
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        _reuseCells = [[NSMutableSet alloc] init];
        _cellClass = [UITableViewCell class];
        _reuseSections = [[NSMutableSet alloc] init];
        _sectionClass = [LeftSectionView class];
    }
    return self;
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame cellClass:(_Nonnull Class)cellClass sectionClass:(_Nonnull Class)sectionClass{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        _reuseCells = [[NSMutableSet alloc] init];
        _cellClass = cellClass;
        _reuseSections = [[NSMutableSet alloc] init];
        _sectionClass = sectionClass;
    }
    return self;
}

//更新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    [self refreshView];
}

- (void)refreshView{
    
    // 计算所有的cell的数目
    NSInteger rowsNum = 0;
    for (NSInteger i = 0; i < self.numberSections; i++) {
        rowsNum += [self.dataSource tableView:self numberOfRowsInSection:i];
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, rowsNum * [self getRowHeight]);
    
    //删除不再可见的细胞
    for (UIView * cell in [self cellSubViews]) {
        //滑出顶部的cell
        if (cell.frame.origin.y + cell.frame.size.height < self.contentOffset.y) {
            [self recycleCell:cell];
        }
        
        //底部没有出现的cell
        if (cell.frame.origin.y > self.contentOffset.y + self.frame.size.height) {
            [self recycleCell:cell];
        }
    }
    
    //确保每一行都有一个单元格
    int firstVisibleIndex = MAX(0, floor(self.contentOffset.y / [self getRowHeight]));
    int lastVisibleIndex = MIN(rowsNum, firstVisibleIndex + 1 + ceil(self.frame.size.height / [self getRowHeight]));
    
    // 计算显示的cell的indexPath范围
    NSInteger rows = 0;
    for (NSInteger i = 0; i < self.numberSections; i++) {
        NSInteger sectionRows = [self.numberRowsNum[i] integerValue];
        for (NSInteger j = 0; j < sectionRows; j++) {
            if (rows+j>=firstVisibleIndex && rows+j<=lastVisibleIndex) {
                NSLog(@"refreshView: %zi, %zi", i, j);
                //获得cell
                UIView * cell = [self cellForRow:rows+j];
                
                if (!cell) {
                    //如果cell不存在（没有复用的cell），则创建一个新的cell添加到scrollView中
                    UIView * cell = [_dataSource tableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    float topEdgeForRow = (rows+j) * [self getRowHeight];
                    cell.frame = CGRectMake(0, topEdgeForRow, self.frame.size.width, [self getRowHeight]);
                    [self insertSubview:cell atIndex:0];
                }
            }
            if (rows+j>lastVisibleIndex) {
                break;
            }
        }
        
        if (rows >=firstVisibleIndex && rows <=lastVisibleIndex) {
            // 获取section
            float topEdgeForSection = rows * [self getRowHeight];
            UIView * section = [_dataSource tableView:self viewForSection:i];
            section.frame = CGRectMake(0, topEdgeForSection, [self getSctionWidth], sectionRows*[self getRowHeight]);
            [self insertSubview:section atIndex:10];
        }
        
        rows += sectionRows;
        if (rows>=lastVisibleIndex) {
            break;
        }
    }
}

//从滚动视图返回一个单元格数组，self子视图时单元格
- (NSArray *)cellSubViews{
    NSMutableArray * cells = [[NSMutableArray alloc] init];
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[LeftSectionTableViewCell class]]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

//通过添加一组复用单元格，并从视图中删除它来循环单元格
- (void)recycleCell:(UIView *)cell{
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

//返回给定的单元格，如果不存在则返回nil
- (UIView *)cellForRow:(NSInteger)row{
    float topEdgeForRow = row * [self getRowHeight];
    for (UIView * cell in [self cellSubViews]) {
        if (cell.frame.origin.y == topEdgeForRow) {
            return cell;
        }
    }
    return nil;
}

- (void)registerClassForCells:(Class)cellClass{
    _cellClass = cellClass;
}
-(void)registerClassForSections:(Class)sectionClass{
    _sectionClass = sectionClass;
}

//- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
//    UITableViewCell* cell = [_reuseCells anyObject];
//    if (cell) {
//        [_reuseCells removeObject:cell];
//    }
//    return cell;
//}

//-(nullable __kindof UIView*)dequeueReusableSectionWithIdentifier:(NSString *)identifier{
//    return nil;
//}
- (UITableViewCell *)dequeueReusableCell{
    //首先从复用池获取一个单元格
    UITableViewCell * cell = [_reuseCells anyObject];
    if (cell) {
        [_reuseCells removeObject:cell];
    }
    
    if (!cell) {
        cell = [[_cellClass alloc] init];
    }
    return cell;
}

- (UIView *)dequeueReusableSection{
    //首先从复用池获取一个单元格
    UIView * view = [_reuseSections anyObject];
    if (view) {
        [_reuseSections removeObject:view];
    }
    
    if (!view) {
        view = [[_sectionClass alloc] init];
    }
    return view;
}

//单元格高度
- (CGFloat)getRowHeight{
    CGFloat rowHeight = 50.0f;
    @try {
        if ([self.dataSource rowHeight]) { //自定义的高度
            rowHeight = [self.dataSource rowHeight];
        }
    } @catch (NSException *exception) {//默认高度
        rowHeight = 50.0f;
    } @finally {
        
    }
    return rowHeight;
}

-(CGFloat)getSctionWidth{
    CGFloat sectionWidth = 80.0f;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionWidth)]) {
        sectionWidth = [self.dataSource sectionWidth];
    }
    return sectionWidth;
}


#pragma mark - property setters
- (void)setDataSource:(id<LeftSectionTableViewDataSource>)dataSource{
    _dataSource = dataSource;
    
    self.numberSections = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        self.numberSections = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    NSInteger rowsNum = 0;
    if (self.numberRowsNum == nil) {
        self.numberRowsNum = [[NSMutableArray alloc]init];
    }
    for (NSInteger i = 0; i < self.numberSections; i++) {
        NSInteger num = [self.dataSource tableView:self numberOfRowsInSection:i];
        rowsNum += num;
        [self.numberRowsNum addObject:[NSNumber numberWithInteger:num]];
    }
    
    [self refreshView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self refreshView];
}


@end

@interface LeftSectionView()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* title;
@end


@implementation LeftSectionView{
}
-(id)init{
    if (self = [super init]) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_icon];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 40, 20)];
        [_title setFont:[UIFont systemFontOfSize:16]];
        [_title setTextColor:[UIColor redColor]];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_title];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.layer.borderWidth = 0.4;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGFloat iconY =  (frame.size.height - 20 - 40 - 10)/2;
    CGFloat iconX =  (frame.size.width - 40)/2;
    _icon.frame = CGRectMake(iconX, iconY, 40, 40);
    _title.frame = CGRectMake(0, iconY+40+10, frame.size.width, 20);
}

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    [_icon setImage:[UIImage imageNamed:_iconName]];
}

-(void)setSectionTitle:(NSString *)sectionTitle{
    _sectionTitle = sectionTitle;
    _title.text = sectionTitle;
}
@end
