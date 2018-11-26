//
//  ViewController.m
//  ICEDebug
//
//  Created by wujianrong on 2018/6/13.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ViewController.h"
#import "ICEDebugCommunicationManager.h"
#import "ICEDebugMacro.h"
#import "ICEDebugCommunication.h"
#import "ICEDebugWebCommunication.h"
#import "ICEDebugscreeninfo.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<ICEAsyncSocketManagerDelegate, ICEWebAsyncSocketManagerDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, ICE_DEBUG_SCREEN_WIDTH, 300)];
    view1.backgroundColor = [UIColor greenColor];
    
    UIView* view2 = [[UIView alloc]initWithFrame:CGRectMake(10, 30, ICE_DEBUG_SCREEN_WIDTH-20, 200)];
    view2.backgroundColor = [UIColor redColor];
    

    
    
    UIView* view3 = [[UIView alloc]initWithFrame:CGRectMake(10, 20, ICE_DEBUG_SCREEN_WIDTH-50, 80)];
    view3.backgroundColor = [UIColor yellowColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.text = @"hello world123";
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor greenColor].CGColor;
    label.layer.borderWidth = 2;
    label.layer.masksToBounds = YES;
    [view3 addSubview:label];
    
    UIView* view4 = [[UIView alloc]initWithFrame:CGRectMake(10, ICE_DEBUG_VB(view3)+10, ICE_DEBUG_SCREEN_WIDTH-50, 80)];
    view4.backgroundColor = [UIColor blueColor];
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 100, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"btn 按钮yu" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:23];
    [view4 addSubview:button];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageView* imageView = [self imageWithView:button];
        ICE_DEBUG_MX(imageView, ICE_DEBUG_VR(button)+10);
        ICE_DEBUG_MY(imageView, 10);
        [view4 addSubview:imageView];
    });
    
    
    [self.view addSubview:view1];
    [view1 addSubview:view2];
    [view2 addSubview:view3];
    [view2 addSubview:view4];
    
    UIView* view5 = [[UIView alloc]initWithFrame:CGRectMake(10, ICE_DEBUG_VB(view1)+10, ICE_DEBUG_SCREEN_WIDTH-20, 300)];
    view5.backgroundColor = [UIColor orangeColor];
    UIView* view6 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ICE_DEBUG_SCREEN_WIDTH-50, 80)];
    view6.backgroundColor = [UIColor grayColor];
    UIView* view7 = [[UIView alloc]initWithFrame:CGRectMake(10, ICE_DEBUG_VB(view6)+10, ICE_DEBUG_SCREEN_WIDTH-50, 80)];
    view7.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view5];
    [view5 addSubview:view6];
    [view5 addSubview:view7];
    
    ICEDebugCommunication* ob = [ICEDebugCommunication shared];
    ob.delegate = self;
    [ob startServer];
    
    ICEDebugWebCommunication* webOb = [ICEDebugWebCommunication shared];
    webOb.delegate = self;
    [webOb startServer];
}
    
    -(UIImageView*)imageWithView:(UIView*)view
    {
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[self getImageFromView:view]];
        
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        return imageView;
    }
    
    -(UIImage*)getImageFromView:(UIView*)view
    {
        UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return image;
    }
-(NSString *)processWebMessage:(NSString *)message{
   // return [ConvertViewController convert:self];
    return [ICEDebugscreeninfo convert:nil];
}

-(NSString *)processMessage:(NSString *)message
{
    NSLog(@"%@", message);
    ICEDebugCommunicationManager* ob = [ICEDebugCommunicationManager defaultManager];
    NSString* str = [ob sendCmd:message];
    return str;
}

- (void)viewDidUnload {

    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
