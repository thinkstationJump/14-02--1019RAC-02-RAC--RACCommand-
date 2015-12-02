//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 1.命令执行的时候调用
        NSLog(@"执行SignalBlock");
        // 处理事情,网络请求
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 2.执行完SignalBlock,接着就会调用
            NSLog(@"执行didSubscribe");
            // 传送数据,也只会来一次
            [subscriber sendNext:@"请求到网络数据"];
            
            // 一定要做事情,声明数据传递完成
            // 当数据传递完成,命令就执行完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // 2.订阅信号
    // 信号源,可以拿到正在执行的信号
    // 信号中的信号,signalOfSignals,信号类发出的数据还是一个信号
    //    [command.executionSignals subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //        [x subscribeNext:^(id x) {
    //
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    // 直接获取命令中新发出信号
    // switchToLatest:只能用于signalOfSignals
    // 作用:就是拿到signalOfSignals发出的最新信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 订阅当前命令执行状态的信号,正在执行,没有执行
    [command.executing subscribeNext:^(id x) {
        // x:YES 正在执行
        // x:No 没有执行/执行完成
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"没有执行/执行完成");
        }
        
    }];
    
    // 2.执行命令
    RACSignal *signal = [command execute:@1];

    
    
}

- (void)switchToLatest
{
    
    // 1.创建了一个信号中的信号,只能发送信号
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 创建信号,发送普通数据
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 2.通过订阅信号中信号,拿到signal发出值
    // 获取信号中的信号发送最新信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    // 3.发送信号
    // 信号中的信号发送数据
    [signalOfSignals sendNext:signalA];
    [signalOfSignals sendNext:signalB];
    
    // 信号发送数据
    [signalB sendNext:@"发送普通数据"];
}
- (void)command
{
    
    
    // 3.订阅信号
    //    [signal subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //    }];

}

@end
