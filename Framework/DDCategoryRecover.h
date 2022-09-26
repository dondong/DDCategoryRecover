//
//  DDCategoryRecover.h
//  DDCategoryRecover
//
//  Created by dondong on 2022/9/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCategoryRecover : NSObject
+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector;
+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector recoverBlock:(void (^)(Method method))recoverBlock;
@end

NS_ASSUME_NONNULL_END
