//
//  ViewController.m
//  02、NSURLSession(下载)
//
//  Created by kinglinfu on 16/9/5.
//  Copyright © 2016年 Tens. All rights reserved.
//

/***
    利用代理的模式来实现NSURLSession的网络下载缓存，就是我们平时在生活中下载一个东西时的看见的那个下载进度条
 **/

#import "ViewController.h"
#import "DownLoadPrograssView.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet DownLoadPrograssView *prograssView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self download_delegate];

}


- (void)downloadTask_block {
    
    //获取网络连接地址
    NSURL *url = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/108051051.mp3?vkey=4A95A0FCDFDC050E9D543841CA4A28AABD19F1973177DAB509EEBED09344D0A91A286D0800E7C58751A670CC429DB1118C98F8908C487284&guid=2718671044"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // 1、创建一个下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        // 2、设置保存文件的本地URL
        NSURL *docmentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *dataURL = [docmentsURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        NSError *moveError = nil;
        // 3、讲下载的数据从临时URL移动到知道的URL
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:dataURL error:&moveError];
        if (!moveError) {
            
            NSLog(@"保存成功");
        }
        
        NSLog(@"%@",location);
        
    }];
    
    [downloadTask resume];
}




- (void)download_delegate {
    
    NSURL *url = [NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv.jpg"];
    
    // 1、配置NSURLSession并设置代理，delegateQueue：代理执行的线程
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithURL:url];
    
    [downTask resume];
    
}

#pragma mark - <NSURLSessionDownloadDelegate>
//下载完成后调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"下载完成 %@",NSHomeDirectory());
    
    // 1、设置保存文件的本地URL
    NSURL *docmentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *dataURL = [docmentsURL URLByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    NSError *moveError = nil;
    // 2、讲下载的数据从临时URL移动到知道的URL
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:dataURL error:&moveError];
    if (!moveError) {
        
        NSLog(@"保存成功");
    }
}

// 监听下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    // bytesWritten: 时间点下载的数据大小 totalBytesWritten：已经下载的数据大小，totalBytesExpectedToWrite: 下载文件的总大小
    
    self.prograssView.prograss = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    NSLog(@"%lld, %lld, %lld ",bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}



@end
