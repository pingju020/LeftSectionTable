//
//  ViewController.m
//  LeftSectionTable
//
//  Created by yangjuanping on 2018/9/30.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//
#import "LeftSectionTableView.h"
#import "LeftSectionTableViewCell.h"
#import "ViewController.h"

#define SCREEB_SIZE [UIScreen mainScreen].bounds.size

@interface ViewController ()<LeftSectionTableViewDataSource>

@property (nonatomic,strong) LeftSectionTableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[LeftSectionTableView alloc] initWithFrame:CGRectMake(0, 20, SCREEB_SIZE.width, SCREEB_SIZE.height - 20)];
    self.tableView.dataSource = self;
    [self.tableView registerClassForCells:[LeftSectionTableViewCell class]];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(LeftSectionTableView *)tableView{
    return 3;
}

- (NSInteger)numberOfRows{
    return 30;
}

- (UIView *)cellForRow:(NSInteger)row{
    //    NSString * ident = @"cell";
    //    LeftSectionTableViewCell * cell = [[LeftSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    LeftSectionTableViewCell * cell = (LeftSectionTableViewCell *)[self.tableView dequeueReusableCell];
    cell.textLabel.text = @"测试";
    return cell;
}

- (NSInteger)tableView:(LeftSectionTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
        case 1:
            return 15;
        default:
            return 5;
    }
}

- (UITableViewCell *)tableView:(LeftSectionTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftSectionTableViewCell * cell = (LeftSectionTableViewCell *)[self.tableView dequeueReusableCell];
    cell.textLabel.text = [NSString stringWithFormat:@"测试 %zi, %zi", indexPath.section, indexPath.row];
    NSLog(@"indexPath:%zi, %zi", indexPath.section, indexPath.row);
    return cell;
}

- (CGFloat)rowHeight{
    return 55;
}

-(CGFloat)sectionWidth{
    return 100;
}

-(UIView*)tableView:(LeftSectionTableView *)tableView viewForSection:(NSInteger)section{
    LeftSectionView* sectionView = (LeftSectionView*)[tableView dequeueReusableSection];
    sectionView.iconName = @"Image";
    sectionView.sectionTitle =[NSString stringWithFormat: @"Section %zi", section];
    return sectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
