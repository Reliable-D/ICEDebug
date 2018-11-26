//
//  ICEDebugremoveview.h
//  ICEDebug
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugBaseCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEDebugremoveview : ICEDebugBaseCommand
+(NSMutableDictionary*)getPublicViewMapping;
    +(UIView*)lastView;
    +(void)setLastView:(UIView*)view;
@end

@interface _ICEDebugRemoveViewStructs : NSObject
    @property(nonatomic, strong) UIView* view;
    @property(nonatomic, strong) UIView* superView;
    @property(nonatomic, strong) UIView* lastView;
    @property(nonatomic, assign) CGRect frame;
    @property(nonatomic, assign) CGFloat alpha;
@end

NS_ASSUME_NONNULL_END
