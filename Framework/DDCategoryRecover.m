//
//  DDCategoryRecover.m
//  DDCategoryRecover
//
//  Created by dondong on 2022/9/25.
//

#import "DDCategoryRecover.h"
#import <mach/mach.h>
#import <dlfcn.h>
#import <objc/runtime.h>

@implementation DDCategoryRecover
+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector
{
    BOOL isStatics = NO;
    Class c = [target class];
    if (c == target) {
        c = *(Class *)(__bridge void *)target;
        isStatics = YES;
    }
    void *pc = __builtin_return_address(0);
    Dl_info info;
    dladdr(pc, &info);
    do {
        Method m = NULL;
        if (isStatics) {
            m = class_getClassMethod(c, selector);
        } else {
            m = class_getInstanceMethod(c, selector);
        }
        IMP imp = method_getImplementation(m);
        int hit = 0;
        unsigned int count = 0;
        Method *list = class_copyMethodList(c, &count);
        for (int i = 0; i < count; ++i) {
            if (method_getName(list[i]) == selector && (imp == info.dli_saddr || hit > 0)) {
                hit++;
                if (hit > 1) {
                    void (*ptr)(id, SEL) = (void (*)(id, SEL))method_getImplementation(list[i]);
                    ptr(target, selector);
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
