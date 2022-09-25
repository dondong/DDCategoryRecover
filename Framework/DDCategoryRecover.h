//
//  DDCategoryRecover.h
//  DDCategoryRecover
//
//  Created by dondong on 2022/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCategoryRecover : NSObject
+ (void)recoverCurrentMethodWithTarget:(id)target selector:(SEL)selector;
@end

NS_ASSUME_NONNULL_END
