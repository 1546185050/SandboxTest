//
//  ViewController.m
//  SandboxDemo
//
//  Created by dhp on 29/11/16.
//  Copyright © 2016年 dhp. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //测试沙盒目录路径
//    [self testPath];
//    [self personEncode];
//    [self personDecode];
//    [self contentEncode];
//    [self contentDecode];
    [self foundationEncode];
    [[self class] writefile:@"xyz" fileName:@"test.plist"];
}

/**
 *  测试沙盒目录路径
 */
-(void)testPath
{
    //.app
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
    //Tmp
    NSLog(@"Tmp路径：%@",NSTemporaryDirectory());
    //Document
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    NSLog(@"Document路径：%@",documentPath);
    //Library
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryPaths objectAtIndex:0];
    NSLog(@"Library路径：%@",libraryPath);
    /*NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde)参数含义：
     (1)directory
     NSSearchPathDirectory类型的enum值，表明我们要搜索的目录名称，比如用NSDocumentDirectory表明要搜索的是Documents目录。如果将其换成NSCachesDirectory就表示我们搜索的是Library/Caches目录。
     (2)domainMask
     NSSearchPathDomainMask类型的enum值，指定搜索范围，这里的NSUserDomainMask表示搜索的范围限制于当前应用的沙盒目录。还可以写成NSLocalDomainMask（表示/Library）、NSNetworkDomainMask（表示/Network）等。
     (3)expandTilde
     BOOL值，表示是否展开波浪线~。我们知道在iOS中~的全写形式是/User/userName，该值为YES即表示写成全写形式，为NO就表示直接写成“~”。
     */
    //mainbundle
    NSLog(@"BundlePath:%@",[[NSBundle mainBundle] bundlePath]);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"month" ofType:@"png"];
    NSLog(@"imagePath:%@",imagePath);
}

/**
 *  偏好设置存储:一般存储用户名、密码等重要的小数据信息
 */
-(void)setPreference
{
    //创建NSUserDefaults对象 单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //设置数据
    UIImage *image =[UIImage imageNamed:@"month"];
    NSData *imageData = UIImageJPEGRepresentation(image, 100);//把image归档为NSData
    [userDefaults setObject:imageData forKey:@"image"];
    
    [userDefaults setBool:YES forKey:@"autoLogin"];
    [userDefaults setObject:@"NAME" forKey:@"name"];
    [userDefaults setInteger:123456 forKey:@"pwd"];
    
    //立即存储
    [userDefaults synchronize];
    //方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
    
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject]);
}

/**
 *  foundation框架中对象归档
 */
-(void)foundationEncode
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path  stringByAppendingPathComponent:@"test.plist"];
    NSArray *arr = @[@"123",@"456",@"789"];
    if ([NSKeyedArchiver archiveRootObject:arr toFile:filePath]) {
        NSLog(@"foundation框架中对象归档成功");
    }
//    NSArray *arr2 = @[@"abc",@"def"];
//    if ([arr2 writeToFile:filePath atomically:YES]) {
//        NSLog(@"write成功");
//        NSLog(@"%@",filePath);
//    }
    
}

/**
 *  oundation框架中对象解档
 */
-(void)foundationDecode
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path  stringByAppendingPathComponent:@"test.plist"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@",arr);
}

/**
 *  自定义内容归档
 */
-(void)contentEncode
{
    //获取document路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"test1.plist"];
    
    //1. 使用NSData存放归档数据
    NSMutableData *data = [NSMutableData data];
    //2.创建归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //3. 添加归档内容 （设置键值对）
    [archiver encodeObject:@"one" forKey:@"one"];
    [archiver encodeObject:@[@"1",@"2"] forKey:@"12"];
    [archiver encodeInt:123 forKey:@"123"];
    //4. 完成归档
    [archiver finishEncoding];
    //5. 将归档的信息存储到磁盘上
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"自定义内容归档成功");
    }
}

/**
 *  自定义内容解档
 */
-(void)contentDecode
{
    //获取document路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"test1.plist"];
    
    NSData *unarchiverData = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
    NSString *str1 = [unarchiver decodeObjectForKey:@"one"];
    NSLog(@"%@",str1);
}

/**
 *  对自定义对象进行归档
 */
-(void)personEncode
{
    //创建Person对象
    Person *person = [[Person alloc]init];
    
    //给person赋值
    person.personName = @"APPLE";
    person.personPhone = @"123456";
    
    //获取document路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"personTest.plist"];
    
    //通过归档的方式存储
    if([NSKeyedArchiver archiveRootObject:person toFile:filePath])
    {
        NSLog(@"自定义对象归档成功");
    }
    
}

/**
 *  自定义对象解档
 */
-(void)personDecode
{
    //获取document路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接路径
    NSString *filePath = [path stringByAppendingPathComponent:@"personTest.plist"];
    
    //解档
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
    NSLog(@"--%@--%@--",person.personName,person.personPhone);
    
}
/**
 *  追加写入数据到沙盒路径
 *
 *  @param string   要写入的字符串
 *  @param fileName 把数据写入的文件名
 */

+(void)writefile:(NSString *)string fileName:(NSString *)fileName
{
    NSLog(@"fileName==%@",fileName);
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSLog(@"-------文件不存在，写入文件----------");
        NSError *error;
        if([string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error])
        {
            NSLog(@"------写入文件------success");
        }
        else
        {
            NSLog(@"------写入文件------fail,error==%@",error);
        }
    }
    else//追加写入文件，而不是覆盖原来的文件
    {
        NSLog(@"-------文件存在，追加文件----------");
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
        
        
        NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        [fileHandle writeData:stringData]; //追加写入数据
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
