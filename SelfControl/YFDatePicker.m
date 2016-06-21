//
//  YFDatePicker.m
//  SelfControl
//
//  Created by 孙云 on 16/6/20.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFDatePicker.h"
#import <objc/runtime.h>
@implementation YFDatePicker

- (instancetype)init{

    self = [super init];
    if (self) {
        [self setPicker];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setPicker];
    }
    return self;
}

- (void)setPicker{

    self.backgroundColor = [UIColor blackColor];
}
- (void)setTextColor{

    //获取所有的属性，去查看有没有对应的属性
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([UIDatePicker class], &count);
    for(int i = 0;i < count;i ++){
    
        //获得每一个属性
        objc_property_t property = propertys[i];
        //获得属性对应的nsstring
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //输出打印看对应的属性
        NSLog(@"propertyname = %@",propertyName);
        if ([propertyName isEqualToString:@"textColor"]) {
            [self setValue:[UIColor whiteColor] forKey:propertyName];
        }
    }
}
@end
