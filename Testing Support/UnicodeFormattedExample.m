//
//  Foo.m
//  Foo
//
//  Created by Foo on 2/23/17.
//  Copyright © 2017 Square, Inc. All rights reserved.
//


@interface Foo
@end


@implementation Foo
- (void)hi
{
    IM_A_MACRO();

    id literal = @{
        @"😅" : @"😭",
    };
}
@end
