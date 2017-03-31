//
//  ViewController.m
//  ExtensionTest
//
//  Created by YaoYaoX on 17/1/5.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "ViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logAppPath];
}

#pragma mark - 插件的显示隐藏

- (IBAction)showWidget:(id)sender {
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.YY.ExtensionTest.YYExtension"];
}

- (IBAction)hideWiget:(id)sender {
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.YY.ExtensionTest.YYExtension"];
}

#pragma mark - group区数据读写

- (NSString *)groupName{
    return  @"group.YYWidgetGroup.ExtensionTest.YY.com";
}

- (IBAction)readGroupDataFromUserDefault {
    NSUserDefaults *groupDefalut = [[NSUserDefaults alloc] initWithSuiteName:[self groupName]];
    id randomValue = [groupDefalut valueForKey:@"radomvalue"];
    NSLog(@"userDefault: read: %@",randomValue);
}


- (IBAction)writeGroupDataFromUserDefault {
    NSUserDefaults *groupDefalut = [[NSUserDefaults alloc] initWithSuiteName:[self groupName]];
    
    id randomValue = @(arc4random_uniform(100));
    [groupDefalut setValue:randomValue forKey:@"radomvalue"];
    [groupDefalut synchronize];
    NSLog(@"userDefault: write: %@",randomValue);
}

- (IBAction)readGroupDataByNsFileManager {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *groupUrl = [fm containerURLForSecurityApplicationGroupIdentifier:[self groupName]];
    NSURL *fileUrl = [groupUrl URLByAppendingPathComponent:@"Library/Caches/good"];
    NSString *value = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"text: read: %@",value);
}


- (IBAction)writeGroupDataByNsFileManager {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *groupUrl = [fm containerURLForSecurityApplicationGroupIdentifier:[self groupName]];
    NSURL *fileUrl = [groupUrl URLByAppendingPathComponent:@"Library/Caches/good"];
    NSString *value = [NSString stringWithFormat:@"group write test %d", arc4random_uniform(100)];
    [value writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"text: write: %@",value);
}

- (void)logAppPath
{
    //app group路径
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:[self groupName]];
    NSLog(@"app group:\n%@\n\n",containerURL.path);
    
    //打印可执行文件路径
    NSLog(@"bundle:\n%@\n\n",[[NSBundle mainBundle] bundlePath]);
    
    //打印documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"documents:\n%@\n",path);
}

@end
