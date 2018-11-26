//
//  ICEDebugscreeninfo.h
//  ICEDebug
//
//  Created by apple on 2018/11/23.
//  Copyright © 2018年 wanda. All rights reserved.
//

#import "ICEDebugBaseCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEDebugscreeninfo : ICEDebugBaseCommand
    +(NSString*)convert:(UIViewController*)vc;
    +(UIImage*)getImageWithKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
