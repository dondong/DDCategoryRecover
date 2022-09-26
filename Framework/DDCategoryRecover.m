//
//  DDCategoryRecover.m
//  DDCategoryRecover
//
//  Created by dondong on 2022/9/25.
//

#import "DDCategoryRecover.h"
#import <mach/mach.h>
#import <dlfcn.h>

@implementation DDCategoryRecover
+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector
{
    void *pc = __builtin_return_address(0);
    [self _recoverCurrentMethodWithTarget:target selector:selector pc:pc recoverBlock:^(Method method) {
        void (*ptr)(id, SEL) = (void (*)(id, SEL))method_getImplementation(method);
        ptr(target, selector);
    }];
}

+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector recoverBlock:(void (^)(Method method))recoverBlock {
    void *pc = __builtin_return_address(0);
    [self _recoverCurrentMethodWithTarget:target selector:selector pc:pc recoverBlock:recoverBlock];
}

+ (void)_recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector pc:(void *)pc recoverBlock:(void (^)(Method method))recoverBlock
{
    Class c = [target class];
    if (c == target) {
        c = *(Class *)(__bridge void *)target;
    }
    Dl_info info;
    dladdr(pc, &info);
    do {
        Method m = NULL;
        int hit = 0;
        unsigned int count = 0;
        Method *list = class_copyMethodList(c, &count);
        for (int i = 0; i < count; ++i) {
            if (method_getName(list[i]) == selector &&
                (method_getImplementation(list[i]) == info.dli_saddr || hit > 0)) {
                hit++;
                IMP imp1 = method_getImplementation(list[i]);
                if (hit > 1) {
                    recoverBlock(list[i]);
                }
            }
        }
        free(list);
        if (hit > 0) {
            break;
        }
        c = class_getSuperclass(c);
    } while(c != Nil);
}
@end
