//
//  ViewController.m
//  03、NSURLSesssion(上传)
//
//  Created by kinglinfu on 16/9/6.
//  Copyright © 2016年 Tens. All rights reserved.
//

/***
    如何利用网络实现上传，需要注意的是，上传只能用POST这个格式的来进行上传，除去这个以外将不能实现上传功能！
 **/

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self sessionUpload_block];
    [self sessionUpload_delegate];
}

#pragma mark - Block block形式
- (void)sessionUpload_block {
    
    NSURL *url = [NSURL URLWithString:@"http://www.imageshack.us/index.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
    request.HTTPMethod = @"POST";
    
    /**
     设置请求头的上传文件的内容格式(Content-Type) 为图片类型(image/jpeg)、()
     Content-Type 这里面包含了很多格式，还有文档、音频、视频等格式，需要使用时可以去网上查找
     **/
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求头的响应（Accept）的文本格式（text/html）
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /*
     // 上传方式一：把要上传的数据保存为NSData
     NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"image7.jpeg"], 0.5);
     
     NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
     if (error) {
     NSLog(@"%@",error);
     
     } else {
     
     NSString *reuslt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     
     NSLog(@"%@ \n%@",response, reuslt);
     }
     
     }];
     */
    
    // 上传方式二：使用文件所在的本地的URL
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"image7" withExtension:@"jpeg"];
    
    // NSURL *fileURL = [NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv-001.jpg"];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@",error);
            
        } else {
            
            NSString *reuslt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@ \n%@",response, reuslt);
        }
        
        
    }];
    
    [uploadTask resume];
}


#pragma makr - Delegate 代理的形式
- (void)sessionUpload_delegate {
    
    NSURL *url = [NSURL URLWithString:@"http://www.imageshack.us/index.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
    request.HTTPMethod = @"POST";
    
    // 设置请求头的上传文件的内容格式(Content-Type) 为图片类型(image/jpeg)、()
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求头的响应（Accept）的文本格式（text/html）
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"image7.jpeg"], 0.5);

    NSURLSession *session  = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData];
    
    
    [uploadTask resume];
    
}

#pragma mark - <NSURLSessionDataDelegate>

// 上传完成后调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"%@",response);
}

// 上传出错时调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    NSLog(@"%@",error);
}

// 上传的进度监听
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    
    NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
}



@end
