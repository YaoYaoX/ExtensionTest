//
//  TodayViewController.m
//  YYExtension
//
//  Created by YaoYaoX on 17/1/5.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;

@end

@implementation TodayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"nib 加载");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.hidden = YES;
    [self setPreferredContentSize:CGSizeMake(self.view.bounds.size.width, 500)];
    [self logAppPath];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)openContainingApp:(UIButton *)btn{
    
    _slider.value = arc4random_uniform(100)/100.0;
    
    
    __weak typeof (self) weakSelf = self;
    [self.extensionContext openURL:[NSURL URLWithString:@"YYExtension://"] completionHandler:^(BOOL success) {
        weakSelf.msgLbl.text = success? @"success" : @"fail";
    }];
}

- (NSString *)groupName{
    return  @"group.YYWidgetGroup.ExtensionTest.YY.com";
}

- (IBAction)readGroupDataFromUserDefault {
    NSUserDefaults *groupDefalut = [[NSUserDefaults alloc] initWithSuiteName:[self groupName]];
    id randomValue = [groupDefalut valueForKey:@"radomvalue"];
    self.msgLbl.text = [NSString stringWithFormat:@"userDefault: read: %@",randomValue];
}


- (IBAction)writeGroupDataFromUserDefault {
    NSUserDefaults *groupDefalut = [[NSUserDefaults alloc] initWithSuiteName:[self groupName]];
    
    id randomValue = @(arc4random_uniform(100));
    [groupDefalut setValue:randomValue forKey:@"radomvalue"];
    [groupDefalut synchronize];
    self.msgLbl.text = [NSString stringWithFormat:@"userDefault: write: %@",randomValue];
}

- (IBAction)readGroupDataByNsFileManager {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *groupUrl = [fm containerURLForSecurityApplicationGroupIdentifier:[self groupName]];
    NSURL *fileUrl = [groupUrl URLByAppendingPathComponent:@"Library/Caches/good"];
    NSString *value = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
    self.msgLbl.text = [NSString stringWithFormat:@"text: read: %@",value];
}


- (IBAction)writeGroupDataByNsFileManager {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *groupUrl = [fm containerURLForSecurityApplicationGroupIdentifier:[self groupName]];
    NSURL *fileUrl = [groupUrl URLByAppendingPathComponent:@"Library/Caches/good"];
    NSString *value = [NSString stringWithFormat:@"group write test %d", arc4random_uniform(100)];
    [value writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    self.msgLbl.text = [NSString stringWithFormat:@"text: write: %@",value];
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
