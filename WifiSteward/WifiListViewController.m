//
//  WifiListViewController.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/12/1.
//  Copyright © 2015年 zhuang chaoxiao. All rights reserved.
//

#import "WifiListViewController.h"
#import "WifiTableViewCell.h"
#import "CommData.h"
#import "SVProgressHUD.h"

@interface WifiListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSURLConnection * conn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WifiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 50;

    self.title = @"免费WIFI";
    
    //不显示WIFI
    if( ![self showWIFI] )
    {
        _tableView.hidden = YES;
        
        [self startConnect];
        
        [SVProgressHUD showWithStatus:@"正在为您寻找免费WIF，请稍等!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
           
            [SVProgressHUD showErrorWithStatus:@"在您的附近没有找到免费的WIFI！"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }
}

-(void)startConnect
{
    NSURL * url = [NSURL URLWithString:@"http://www.hushup.com.cn/eBook/"];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    conn = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId = @"WifiTableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if( !cell )
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] lastObject];
    }
    
    
    [((WifiTableViewCell*)cell) refreshCell:indexPath.row withVC:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}


-(BOOL)showWIFI
{
    NSDateComponents * data = [[NSDateComponents alloc]init];
    NSCalendar * cal = [NSCalendar currentCalendar];
    
    [data setCalendar:cal];
    [data setYear:EXTERN_YEAR];
    [data setMonth:EXTERN_MONTH];
    [data setDay:EXTERN_DAY];
    
    NSDate * farDate = [cal dateFromComponents:data];
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval farSec = [farDate timeIntervalSince1970];
    NSTimeInterval nowSec = [now timeIntervalSince1970];
    
    if( nowSec - farSec >= 0 )
    {
        return YES;
    }
    
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
