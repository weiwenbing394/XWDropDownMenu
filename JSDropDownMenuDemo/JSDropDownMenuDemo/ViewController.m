//
//  ViewController.m
//  JSDropDownMenuDemo
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import "ViewController.h"
#import "JSDropDownMenu.h"

@interface ViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData1SelectedIndex;
    
    JSDropDownMenu *menu;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray  *_arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    NSMutableArray *privice =[NSMutableArray array];
    NSMutableArray *shi=[NSMutableArray array];
    for (NSDictionary * dic in _arrayRoot) {
        [privice addObject:dic[@"state"]];
        NSArray *shiArray=dic[@"cities"];
        NSMutableArray *cityArr=[NSMutableArray array];
        for (NSDictionary *shiDic in shiArray) {
            [cityArr addObject:shiDic[@"city"]];
        }
        [shi addObject:cityArr];
    }
    _data1=[[NSMutableArray alloc]initWithObjects:@{@"title":@"不限", @"data":@[@"全国"]}, nil];
    for (int i=0;i<privice.count;i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:privice[i] forKey:@"title"];
        [dic setValue:shi[i] forKey:@"data"];
        [_data1 addObject:dic];
    }
    _data2 = [NSMutableArray arrayWithObjects:@"不限", @"男", @"女", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限人数", @"单人餐", @"双人餐", @"3~4人餐", nil];
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 20) andHeight:45 inView:self.view];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}


- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column==2) {
        return YES;
    }
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    if (column==0) {
        return 1/3.0;
    }
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        if (leftOrRight==0) {
            return _data1.count;
        } else{
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        return _data2.count;
    } else if (column==2){
        return _data3.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: return _data3[_currentData3Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        return _data2[indexPath.row];
    } else {
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            _currentData1Index = indexPath.row;
            return;
        }
    } else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
    } else{
        _currentData3Index = indexPath.row;
    }
}



@end
