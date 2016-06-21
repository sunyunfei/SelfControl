//
//  ViewController.m
//  SelfControl
//
//  Created by 孙云 on 16/6/20.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import "YFDatePicker.h"
#import <objc/runtime.h>
@interface ViewController ()
{

    YFDatePicker *picker;
    UIAlertAction *alertOk;
    UIAlertAction *alertCancel;
    UIAlertController *alert;
}

- (IBAction)clickFirstBtn:(id)sender;
- (IBAction)clickSecBtn:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载
    [self loadDatePicker];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  加载datepicker
 */
- (void)loadDatePicker{

     picker = [[YFDatePicker alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 216)];
    [picker setTextColor];
    [self.view addSubview:picker];
    
    [picker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
}
- (void)chooseDate:(YFDatePicker *)sender{

    NSDate *date = sender.date;
    NSLog(@"时间:%@",date);
}
/**
 *  弹出alert
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickFirstBtn:(id)sender {
    
    alert = [UIAlertController alertControllerWithTitle:@"弹出框" message:@"你看我的颜色" preferredStyle:UIAlertControllerStyleAlert];
    
    alertOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"哎呦，确定了");
    }];
    [alert addAction:alertOk];
    alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"呦西，取消");
    }];
    [alert addAction:alertCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    //设置字体颜色
    [self setAlertTextColor];
}
/**
 *  弹出uiactionsheet
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickSecBtn:(UIButton *)sender {
    
}
- (void)setAlertTextColor{

    //首先获得对应的属性
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([UIAlertAction class], &count);
    for(int i = 0;i < count;i ++){
    
        objc_property_t property = propertys[i];
        //获得属性名对应字符串
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSLog(@"uialertion.property = %@",propertyName);
    }
    
    //获得成员变量
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++){
    
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"uialertion.ivarName = %@",ivarName);
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            
            [alertOk setValue:[UIColor blueColor] forKey:@"titleTextColor"];
            [alertCancel setValue:[UIColor purpleColor] forKey:@"titleTextColor"];
        }
    }
    
 /********************************************************************/
    //改变显示提示字体颜色
    objc_property_t *propertyss = class_copyPropertyList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        
        objc_property_t propertys = propertyss[i];
        //获得属性名对应字符串
        NSString *propertyNames = [NSString stringWithCString:property_getName(propertys) encoding:NSUTF8StringEncoding];
        NSLog(@"UIAlertController.property = %@",propertyNames);
    }
    
    Ivar *ivarss = class_copyIvarList([UIAlertController class], &count);
    for(int i =0;i < count;i ++){
        
        Ivar ivars = ivarss[i];
        NSString *ivarNames = [NSString stringWithCString:ivar_getName(ivars) encoding:NSUTF8StringEncoding];
        
        NSLog(@"UIAlertController.ivarName = %@",ivarNames);
        if ([ivarNames isEqualToString:@"_attributedTitle"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"我是标题" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
            [alert setValue:attr forKey:@"attributedTitle"];
        }
        
        if ([ivarNames isEqualToString:@"_attributedMessage"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"土豆哪里去挖,土豆山沟里挖" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:25]}];
            [alert setValue:attr forKey:@"attributedMessage"];
        }
    }
}
@end
