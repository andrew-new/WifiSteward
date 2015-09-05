//
//  MainViewController.m
//  Laugh
//
//  Created by zhuang chaoxiao on 15/8/30.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "LaughViewController.h"
#import "BaiduMobAdView.h"

@import GoogleMobileAds;

//
@interface LaughViewController ()<BaiduMobAdViewDelegate,UIScrollViewDelegate>
{
    
    GADBannerView * changeGood;
    BaiduMobAdView * changeBaidu;
    
    UIScrollView * scrView;
    
    NSMutableArray * webArray;
    
    int curIndex;
}
@end

@implementation LaughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    scrView.pagingEnabled = YES;
    scrView.delegate = self;
    [self.view addSubview:scrView];
    
    NSArray * urlArray = @[@"http://m.toutiao.com/m3317437476/",@"http://m.toutiao.com/m3526696021/",@"http://m.toutiao.com/m2773452475/",@"http://m.toutiao.com/m3435246861/",@"http://m.toutiao.com/m3022137488/",@"http://m.toutiao.com/m3261238908/"];
    
    //
    webArray = [NSMutableArray new];
    
    //
    for( int i = 0;i < urlArray.count; ++ i )
    {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(i*bounds.size.width, 0, bounds.size.width, bounds.size.height)];
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlArray objectAtIndex:i]]];
        [webView loadRequest:req];
        
        [scrView addSubview:webView];
        
        //
        [webArray addObject:webView];
    }
    
    scrView.contentSize = CGSizeMake(bounds.size.width * urlArray.count, bounds.size.height);
    
    //
    
    [self laytouADVView];
    
    //
    
    [self layoutBtns];
    
    //
}

-(void)layoutBtns
{
    #define BTN_WIDTH  60
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    UIButton * lBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, bounds.size.height - BTN_WIDTH, BTN_WIDTH, BTN_WIDTH)];
    [lBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:lBtn];
    
    
    UIButton * rBtn = [[UIButton alloc]initWithFrame:CGRectMake(bounds.size.width-BTN_WIDTH-10, bounds.size.height - BTN_WIDTH, BTN_WIDTH, BTN_WIDTH)];
    [rBtn setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(forClicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rBtn];
}


-(void)backClicked
{
    UIWebView * webView = [webArray objectAtIndex:curIndex];
    [webView goBack];
}

-(void)forClicked
{
    UIWebView * webView = [webArray objectAtIndex:curIndex];
    [webView goForward];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    curIndex = scrView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}


//底部广告
-(void)laytouADVView
{
    {
        CGPoint pt ;
        
        pt = CGPointMake(0, 0);
        changeGood = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
        
        changeGood.adUnitID = @"ca-app-pub-3058205099381432/7586204749";//调用你的id
        changeGood.rootViewController = self;
        [changeGood loadRequest:[GADRequest request]];
        
        [self.view addSubview:changeGood];
    }
    
    {
        CGPoint pt = CGPointMake(0, 0);
        
        changeBaidu = [[BaiduMobAdView alloc]init];
        changeBaidu.AdType = BaiduMobAdViewTypeBanner;
        changeBaidu.frame = CGRectMake(0, pt.y, kBaiduAdViewBanner468x60.width, kBaiduAdViewBanner468x60.height);
        
        changeBaidu.delegate = self;
        [self.view addSubview:changeBaidu];
        [changeBaidu start];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(changeAdv) userInfo:nil repeats:YES];
    
    //
    {
        
        CGRect rect = [[UIScreen mainScreen]bounds];
        CGPoint pt = CGPointMake(0, rect.origin.y+rect.size.height-kBaiduAdViewBanner468x60.height-1);
        
        BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
        _baiduView.AdType = BaiduMobAdViewTypeBanner;
        _baiduView.frame = CGRectMake(0, pt.y, kBaiduAdViewBanner468x60.width, kBaiduAdViewBanner468x60.height);
        
        _baiduView.delegate = self;
        [self.view addSubview:_baiduView];
        [_baiduView start];
    }
}

-(void)changeAdv
{
    static int index = 0;
    
    if( index % 2 == 0 )
    {
        changeGood.hidden = NO;
        changeBaidu.hidden = YES;
    }
    else
    {
        changeGood.hidden = YES;
        changeBaidu.hidden = NO;
    }
    
    ++ index;
}

- (NSString *)publisherId
{
    return @"d9348313";
}

/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString*) appSpec
{
    return @"d9348313";
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
