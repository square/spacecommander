#pragma Formatter Exempt     
// Copyright 2015 Square, Inc

#import @"XYZGeometry.h"
#import "Blah.h"
#import <Great.h>


#define RKTAddTestCaseCategoryInterface(klass, name) \
@class klass; \
@interface KIFTestCase (klass##_ConvenienceAdditions) \
@property (nonatomic, readonly, strong) klass *name; \
@end

@interface ProblemChild<NeatInterface>
@property(nonatomic, assign, getter = isWackSpacingGetter, readonly) BOOL wackSpacing;

- (void)performOnMainThreadUsingBlock:(dispatch_block_t)block SQ_DEPRECATED("Should use addOperationWithBlock: on NSOperationQueue's mainQueue. Will be removed after 3/1/2015.");
@end

// The below interface should have its prepended newlines left alone due to this comment
@interface Foo
@end

// The inline constructors here are problematic and will get a semicolon added unless we put them on a single line.
struct Update {
	UpdateType type;
	string value;
	Update()
		: type(UPDATE_WRITE), value("") {
	}
	Update(UpdateType t, const Slice &v)
		: type(t), value(v.data(), v.size()) {
	}
};

/* Same deal here, don't mess with adding newlines after this comment block 
 * with a different comment style 
 * and trailing spaces */  
@implementation Foo
@end

@implementation ProblemChild	

- (void)methodWithParams:(NSString*)param1 another:(BOOL )param2
{
	SQSelfSelector1(_windowDidResignKeyNotification:);
        NSString *keys = [NSSet setWithArray:@[
                        SQTypedKeyPath(MQItemControl, highlighted),
                        SQTypedKeyPath(MQItemControl, enabled),
                        SQTypedKeyPath(MQItemControl, selected)
                                             ]];
	NSArray* testLiteral = @[cool];
	NSDictionary* dictLiteral = @{ @"foo": testLiteral };
	SQCheckCondition(NO,, @"Will the commas stay together?");
}

@end
