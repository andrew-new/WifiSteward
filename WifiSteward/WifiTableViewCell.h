//
//  WifiTableViewCell.h
//  WifiSteward
//
//  Created by zhuang chaoxiao on 15/12/1.
//  Copyright © 2015年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiTableViewCell : UITableViewCell

-(void)refreshCell:(int)row withVC:(UIViewController*)vc;

@end
