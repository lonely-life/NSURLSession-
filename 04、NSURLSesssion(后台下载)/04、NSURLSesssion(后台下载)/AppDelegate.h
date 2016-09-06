//
//  AppDelegate.h
//  04、NSURLSession(后台下载)
//
//  Created by kinglinfu on 16/9/6.
//  Copyright © 2016年 Tens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy, nonatomic) void(^backgroundCompletionHandler)();


@end

