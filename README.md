## Instroduce
To fix some category overwrte some system method, it will call the system method.

## Example
```objective-c
@interface UIView(dd)

@end

@implementation UIView(dd)
+ (void)initialize {
    [DDCategoryRecover recoverCurrentMethodWithTarget:self selector:@selector(initialize)];
    // do something
}
@end
```
