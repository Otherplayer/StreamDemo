//
//  ViewController.m
//  StreamDemo
//
//  Created by __无邪_ on 16/9/27.
//  Copyright © 2016年 __无邪_. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>
@property (nonatomic, assign)NSUInteger location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self doTestInputStream];
    [self doTestOutputStream];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -write


- (void)doTestOutputStream {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"world.js"];
    NSLog(@"%@",path);
    
    NSOutputStream *writeStream = [[NSOutputStream alloc] initToFileAtPath:path append:YES];
    [writeStream setDelegate:self];
    
    [writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [writeStream open];
}


- (NSData *)dataWillWrite {
    static  NSData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hello.js" ofType:nil];
        data = [NSData dataWithContentsOfFile:path];
    });
    
    return data;
}


#pragma mark - read

- (void)doTestInputStream {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hello.js" ofType:nil];
    
    NSInputStream *readStream = [[NSInputStream alloc]initWithFileAtPath:path];
    [readStream setDelegate:self];
    
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [readStream open]; //调用open开始读文件
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:{//读
            
            uint8_t buf[1024];
            
            NSInputStream *reads = (NSInputStream *)aStream;
            NSInteger blength = [reads read:buf maxLength:sizeof(buf)]; //把流的数据放入buffer
            NSData *data = [NSData dataWithBytes:(void *)buf length:blength];
            
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }
            break;

        case NSStreamEventHasSpaceAvailable: {//写
            
            NSInteger bufSize = 5;
            uint8_t buf[bufSize];
            
            if (self.location + bufSize > [self dataWillWrite].length) {
                [[self dataWillWrite] getBytes:buf
                                         range:NSMakeRange(self.location, self.location + bufSize - [self dataWillWrite].length)];
            }
            else {
                [[self dataWillWrite] getBytes:buf range:NSMakeRange(self.location, bufSize)];
            }
            
            NSOutputStream *writeStream = (NSOutputStream *)aStream;
            [writeStream write:buf maxLength:sizeof(buf)]; //把buffer里的数据，写入文件
            
            self.location += bufSize;
            if (self.location >= [[self dataWillWrite] length] ) { //写完后关闭流
                [aStream close];
            }
            
        }
            break;
            
        case NSStreamEventEndEncountered: {
            [aStream close];
        }
            break;
            
            //错误和无事件处理
        case NSStreamEventErrorOccurred:{
            
        }
            break;
        case NSStreamEventNone:
            break;
            
            //打开完成
        case NSStreamEventOpenCompleted: {
            NSLog(@"NSStreamEventOpenCompleted");
            
            
        }
            break;
            
        default:
            break;
    }
}




@end
