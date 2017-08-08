//
//  EnglishViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "EnglishViewController.h"
#import "Header.h"
#import "WordTableViewCell.h"

@interface EnglishModel : NSObject

@property(nonatomic,copy)NSString *ID;

@end

@implementation EnglishModel



@end


@interface EnglishViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>

//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;

//用户数组数据
@property (strong, nonatomic) NSMutableArray *DataArr;
@property(nonatomic,strong)NSMutableArray *searchDataArr;

@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, assign) NSInteger countArr;  //数组个数

@property (nonatomic, strong) NSMutableArray * arr;       //已有字母
@property(nonatomic,strong)NSMutableArray *searchArr;
//侧边字母数组
@property (strong, nonatomic) NSMutableArray *keyArr;
////
//@property (strong, nonatomic) NSMutableArray *dicKey;
//存储每个单词下的字典的字典
@property (strong, nonatomic) NSMutableDictionary *listDic;
@property(nonatomic,strong)NSMutableDictionary *searchListDic;

@property(nonatomic,strong)UISearchController *searchContro;
@end

@implementation EnglishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onItemLeft)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self createWordList];
    
    [self creatSearch];
    
    [self createNibField];
    //获取数据
    [self getTableviewData];
}

-(void)onItemLeft{
    [self.view endEditing: YES];
    self.searchContro.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建searchController
-(void)creatSearch{

    //添加表格展示数据
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight  - 64) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.sectionIndexColor=BLUECOLOR_STYLE;
    self.tableview.tableFooterView = [UIView new];
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"WordTableViewCell" bundle:nil] forCellReuseIdentifier:@"WordCell"];
    
    self.searchContro = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchContro.dimsBackgroundDuringPresentation = NO;
    self.searchContro.hidesNavigationBarDuringPresentation = NO;
    self.searchContro.searchResultsUpdater = self;
    self.searchContro.searchBar.frame = CGRectMake(8, 0, kWith-16, 44);
    self.tableview.tableHeaderView = self.searchContro.searchBar;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = [self.searchContro.searchBar text];
    
    if (searchString !=nil && ![searchString isEqualToString:@""]) {
        
        self.searchArr = [NSMutableArray new];
        //把数据按字母检索出来,放入对应的数组中
        self.searchListDic=[NSMutableDictionary new];
        
        for (char str='A'; str<='Z'; str++)
        {
            NSMutableArray *arrySear=[NSMutableArray new];
            for (NSInteger i=0; i<self.DataArr.count; i++)
            {
                
                NSString *group = self.DataArr[i][@"name"];
                if ([group containsString:searchString]) {
                    
                    if ([self.DataArr[i][@"egroup"] isEqualToString:[NSString stringWithFormat:@"%c",str]])
                    {
                        [arrySear addObject:self.DataArr[i]];
                    }
                }
            }
            //添加不为0的数组
            if (arrySear.count!=0)
            {
                [self.searchListDic setValue:arrySear forKey:[NSString stringWithFormat:@"%c",str]];
                [self.searchArr addObject:[NSString stringWithFormat:@"%c",str]];
            }
        }
        [self.tableview reloadData];
    
    }else
    {
        self.searchArr = [NSMutableArray array];
        self.searchListDic  =[NSMutableDictionary dictionary];
        [self.tableview reloadData];
    }
}

#pragma mark - 创建单词列表
-(void)createWordList
{
    _keyArr=[[NSMutableArray alloc]init];
    //创建字典存储英文开头,对应的单词
    NSMutableDictionary *wordDic=[[NSMutableDictionary alloc]init];
    //创建26个可变数组
    for (char character='A';  character<='Z'; character++)
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [wordDic setObject:arr forKey:[NSString stringWithFormat:@"%c",character]];
        //将a-z 26个字母添加到侧边栏数组中，用于显示
        [self.keyArr addObject:[NSString stringWithFormat:@"%c",character]];
    }
    
    _arr = [NSMutableArray new];
    //把数据按字母检索出来,放入对应的数组中
    self.listDic=[NSMutableDictionary new];
    for (char str='A'; str<='Z'; str++)
    {
        NSMutableArray *mArr=[NSMutableArray new];
        for (NSInteger i=0; i<self.DataArr.count; i++)
        {
            if ([self.DataArr[i][@"egroup"]isEqualToString:[NSString stringWithFormat:@"%c",str]])
            {
                [mArr addObject:self.DataArr[i]];
            }
        }
        //添加不为0的数组
        if (mArr.count!=0)
        {
            [self.listDic setValue:mArr forKey:[NSString stringWithFormat:@"%c",str]];
            _countArr ++ ;
            [_arr addObject:[NSString stringWithFormat:@"%c",str]];
            
        }
    }

    [self.tableview reloadData];
}

#pragma mark - 创建tableView上的Cell文件
-(void)createNibField
{
    //创建nib文件
    UINib *nib=[UINib nibWithNibName:@"WordTableViewCell" bundle:[NSBundle mainBundle]];
    //创建nib试图并注册到tableView中
    [self.tableview registerNib:nib forCellReuseIdentifier:@"WordCell"];
}

//多少个分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchContro.active) {
        return self.searchArr.count;
    }else
    {
        return _countArr;
    }
}

//每个分组有多少个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchContro.active) {
        return [self.searchListDic[self.searchArr[section]] count];
    }else
    {
        return [self.listDic[_arr[section]] count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordCell" forIndexPath:indexPath];

    if (self.searchContro.active) {
        [cell setCell:self.searchListDic[self.searchArr[indexPath.section]][indexPath.row]];
    }else
    {
        [cell setCell:self.listDic[_arr[indexPath.section]][indexPath.row]];
    }
    cell.selectionStyle=NO;
    return cell;
}
//标题内容
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchContro.active) {
        return self.searchArr[section];
    }else
    {
        return _arr[section];
    }
}
//索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keyArr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

#pragma mark - 获取常用英文列表数据
-(void)getTableviewData
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:COMMONLY_USED_ENGLISH heads:heads parameters:nil success:^(id responseObject)
     {
         NSMutableDictionary *DataDic=(NSMutableDictionary *)responseObject;
         self.DataArr=[NSMutableArray new];
         self.DataArr = DataDic[@"value"];
        
         //处理列表数据
         [self createWordList];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigations

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
