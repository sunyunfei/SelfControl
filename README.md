 最近一致比较忙，在做一个需求很多的功能。所以很少来看，趁着早上来到闲一会，把前几天用到的小技巧告诉大家。首先我想说的是我给的是一种思路，怎么解决此类需求的思路，不是我写个uialert大家就知道这uialert。工作犹如逆水行舟，不进则退。共勉。

# 正文
## UIDatePicker
UIDatePicker大家应该不陌生吧，我们在项目中经常使用。一般大家都是需求这样的：

![正常](http://upload-images.jianshu.io/upload_images/1210430-43bc44d3c6acde2a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
但是有的时候吧，ui抽风或者需求下雨我们可能需要这样的：

![操蛋的](http://upload-images.jianshu.io/upload_images/1210430-c08f81cd88be9a3b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
没办法，谁让你是苦逼的程序员，所以你开始征服之路，经过你写出来是这样的：

![无语的](http://upload-images.jianshu.io/upload_images/1210430-2f24bed81daa2851.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
彻底无语了，想唱一首歌：时间都去哪里去了。于是你去找UIDatePicker的各种属性，结果发现并没有改变字体颜色的属性，怎么办，需求在催，ui在催......(此处省略一万字)。现在不用怕，卤煮给你一个简单的思路方法解决它。
首先，我们想想苹果设计这一个控件，不可能不给他的普通的属性方法，改变字体颜色，大小是最普通的属性了吧。那为什么找不到呢，只有一个可能，就像我们提交appstore一样，我们隐藏了。那么，知道了原因就好了我们去找路径解决。闲杂i 我们怎么拿到隐藏的属性呢，不禁想到了runtimer。不管你之前有没有使用过这个东西，以下的你看起来应该不会有障碍。
来，先让我们知道两个东西：
1，objc_property_t 属性的定义，说白了就是这种形式：
```
@property(nonatomic,strong)UILabel *cdLabel;
```
2，Ivar 成员变量的定义，说白了就是这种形式：
```
{

    YFDatePicker *picker;
    UIAlertAction *alertOk;
    UIAlertAction *alertCancel;
    UIAlertController *alert;
}
```
知道这两种的不同，以下的就好进行了。开干：
首先咱们自定义个UIDatePicker，用于改变字体的颜色：
```
#import <UIKit/UIKit.h>

@interface YFDatePicker : UIDatePicker
- (void)setTextColor;//字体颜色
@end
```

其次，.m把构造方法写一下：
```
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
```
然后重点来了：导入runtimer
```
#import <objc/runtime.h>
```
获取到所有的属性
```
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
    }

```
我一句一句翻译一下：
```
//获取所有的属性，去查看有没有对应的属性
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([UIDatePicker class], &count);
```
这个是获取一个数组，一个里面放了对应的属性的数组。class_copyPropertyList这个方法是获取后面对应的UIDatePicker的所有的属性，后面的count是得到这个数组的量。这就是一个方法，获取ivar，method都是对应的class_copy ＋ 名字。
```
//获得每一个属性
        objc_property_t property = propertys[i];
        //获得属性对应的nsstring
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
```
从这个数组里面一一拿出来每一个属性，然后因为这个属性是char类型的，我们转换为字符串类型去做对应的操作。
，好了，我们运行一下输出所有的property，看看有没有我们需要的属性：

![控制台打印](http://upload-images.jianshu.io/upload_images/1210430-ea2f993413bc94bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
结果我们发现有textColor这个属性，鸡冻呀，看着这个属性就想日破天了。
然后我们知道有这个属性，怎么用它呢，这时候kvc的好处来了。直接kvc赋值：
```
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
```
然后我们去看一下运行效果：

![最终效果](http://upload-images.jianshu.io/upload_images/1210430-882f3122eb1f4d09.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
终于搞定啦。
当然你也可以直接这样来：
```
[self setValue:[UIColor whiteColor] forKey:@"textColor"];
```
但是怎么说呢，你如果不获取他的所有属性你是怎么知道的这个属性呢。当然，你之前获取过知道了直接用确实快多了哈。看个人啦！！！
## UIAlert
再来看一个UIAlert的改变。
正常的我们需要的是这样的：

![正常](http://upload-images.jianshu.io/upload_images/1210430-115a09e3114bd0f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
但是有的时候，＊＊的需求（我会不会被某些需求人士狂揍）会需要这样的：

![需求的](http://upload-images.jianshu.io/upload_images/1210430-473d99212b90fb86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
然后我写了这些：
```
 
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

```
接着，没有思路了，去查看了UIAlertController的API,就那几个属性和方法，一只手指头都能数的出来，怎么办。自己写一个，但是赶脚又做的效果没有系统的好。不用怕，卤煮来了。
老样子我们先去获取属性看看：
```
 //首先获得对应的属性
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([UIAlertAction class], &count);
    for(int i = 0;i < count;i ++){
    
        objc_property_t property = propertys[i];
        //获得属性名对应字符串
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSLog(@"uialertion.property = %@",propertyName);
    }
```
结果我们发现输出结果：

![控制台输出](http://upload-images.jianshu.io/upload_images/1210430-5971610a56170ea3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我擦嘞，没有改变字体的属性，这怎么办，难道苹果真的没有，不可能呀......不要着急，我们还没有获取ivar看看呢，说不定就在ivar这：
```
//获得成员变量
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++){
    
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"uialertion.ivarName = %@",ivarName);
}
```
控制台输出：

![输出结果](http://upload-images.jianshu.io/upload_images/1210430-3ebe303534f02d0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
果然呀，上帝在关上窗户的时候，往往不会关紧。我们找到了对应的属性，现在就是赋值了
```
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
```
我们现在是改变了按钮的对应的字体颜色，现在我们去改变内容的字体属性：
```
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

```
你会发现运行结果控制台输出：

![输出](http://upload-images.jianshu.io/upload_images/1210430-f155962e3e778d0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
并没有说textcolor这一类的属性，但是发现了两个野生的_attributedTitle，_attributedMessage。看着就是对应的title和message的字体。当然如果你不熟悉NSAttributedString的话，可以看一下我之前有一篇专门解释这个属性的。
得到这两个我们去改变就很轻松了，直接赋值就ok了。
# 结语
好了，好了，差不多得了，万恶的后台鸡巴又在催我了。我要去码字了，UIActionSheet的字体试着去做一下，还是那句话：
#逆水行舟，只能进，不能退.
