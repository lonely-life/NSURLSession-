//
//  ViewController.m
//  01、NSURLSession
//
//  Created by kinglinfu on 16/9/5.
//  Copyright © 2016年 Tens. All rights reserved.
//

#import "ViewController.h"

#define APPID @"16246"
#define SIGN  @"299df814df3a3d5aba893e9ead3c19bd"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@",NSHomeDirectory());
    
    // [self sessionTask_GET];
    
    // [self sessionTask_POST];
    
    [self sesssionTask_Configuration];
    
}

- (void)sessionTask_GET {
    
    // https://route.showapi.com/213-4?showapi_appid=16246&showapi_timestamp=20160905105517&topid=5&showapi_sign=299df814df3a3d5aba893e9ead3c19bd
    
    //--------------------------------GET请求------------------------------------------------
    // GET请求：获取数据，把参数以URL的形式拼接传给服务器。以 ？ 分开URL地址和参数，& 拼接多个参数
    
    // URL 地址
    NSString *urlStr = @"https://route.showapi.com/213-4?";
    // 请求的参数，
    urlStr = [urlStr stringByAppendingFormat:@"showapi_appid=%@&showapi_timestamp=%@&topid=%@&showapi_sign=%@",APPID,@"20160905142417",@"5",SIGN];
    
    // 1、创建一个URL
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2、创建一个NSURLRequest 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3、创建NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 4、由session创建一个请求数据的任务NSURLSessionDataTask,(会以异步的形式发送网络请求,不会阻塞主线程)
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 执行完后 以block 返回结果，解析数据
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",jsonData);
        
    }];
    
    // 5、开始执行网络任务
    [dataTask resume];
}


//--------------------------------------------POST请求------------------------------------------------
// POST请求时要指明请求的方式HTTPMethod 为 POST,参数以请求体 HTTPMethod 的形式传入。

- (void)sessionTask_POST {
    
    NSURL *url = [NSURL URLWithString:@"http://route.showapi.com/213-4"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 1、设置请求方式为 POST
    request.HTTPMethod = @"POST";
    
    NSString *parmStr = [NSString stringWithFormat:@"showapi_appid=%@&showapi_timestamp=%@&topid=%@&showapi_sign=%@",APPID,@"20160905142817",@"5",SIGN];
    // 2、设置请求体：把参数作为NSData类型传入
    request.HTTPBody = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        // NSLog(@"%@",response);
        
        // 执行完后 以block 返回结果，解析数据
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",jsonData);
        
    }];
    
    [dataTask resume];
    
}


//------------------------------------NSURLSessionConfiguration 网络请求配置--------------------------------------
- (void)sesssionTask_Configuration {
    

    NSString *urlStr = @"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv-001.jpg";
    
    NSURL *url = [NSURL URLWithString:urlStr];

    // NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    /* 设置缓存策略：cachePolicy
     
        NSURLRequestUseProtocolCachePolicy = 0, // 默认，使用缓存，当下一次请求时先判断是否有缓存，有就使用缓存没有才进行网络请求，使用缓存时会先判断缓存是否过期，过期的就重新请求网络。
        NSURLRequestReloadIgnoringLocalCacheData = 1, // 忽略缓存，不使用缓存
        NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // 无视任何的缓存策略，无论是本地的还是远程的，总是从原地址重新下载
        NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,
     
        NSURLRequestReturnCacheDataElseLoad = 2, 首先使用缓存不管是否过期，如果没有本地缓存，才从原地址下载

        NSURLRequestReturnCacheDataDontLoad = 3, 使用本地缓存，从不下载，如果本地没有缓存，则请求失败。此策略多用于离线操作
     
        NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
     
     
     timeoutInterval: 设置请求超时的时间秒数
     
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    
    
    /* NSURLSessionConfiguration：配置网络请求
     
        defaultSessionConfiguration, 默认的模式，可以缓存数据
        ephemeralSessionConfiguration, 无痕浏览，不会有任何的缓存
        backgroundSessionConfigurationWithIdentifier
     */
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 通过 NSURLSessionConfiguration 设置缓存策略
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        NSLog(@"%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];

        });
        
    }];
    
    
    [dataTask resume];
    
}


@end
