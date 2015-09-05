//
//  NewsViewController.m
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/9/5.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "NewsViewController.h"
#import "BaiduMobAdView.h"


@interface NewsViewController ()<BaiduMobAdViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"手机使用技巧";
    
    /*
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        //self.navigationController.navigationBar.titleTextAttributes = dict;
    }
     */
    
    
    NSURL *   url = nil;
    
    int rand = arc4random() / 5;
    
    if(rand == 0 )
    {
        url = [NSURL URLWithString:@"http://toutiao.com/m3395676121/"];
    }
    else if( rand == 1 )
    {
        url = [NSURL URLWithString:@"http://toutiao.com/m3890669865/"];
    }
    else
    {
        url = [NSURL URLWithString:@"http://toutiao.com/m3261496576/"];
    }
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    //
    [self layoutAdv];
    
    //
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height-55, 50, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
}


- (NSString *)publisherId
{
    return @"fece40ae";
}

/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString*) appSpec
{
    return @"fece40ae";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)layoutAdv
{
    BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
    _baiduView.AdType = BaiduMobAdViewTypeBanner;
    _baiduView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, kBaiduAdViewBanner468x60.width, kBaiduAdViewBanner468x60.height);
    _baiduView.delegate = self;
    [self.view addSubview:_baiduView];
    [_baiduView start];
    
}

-(void)backClicked
{
    [_webView goBack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
