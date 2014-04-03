//
//  NWVersionTests.m
//  NWVersionTests
//
//  Created by Nathan Wood on 3/04/2014.
//
//

#import <XCTest/XCTest.h>
#import "NWVersion.h"

@interface NWVersionTests : XCTestCase

@end

@implementation NWVersionTests

- (void)testInvalidStrings
{
    XCTAssertNil([NWVersion versionWithString:nil], @"");
    XCTAssertNil([NWVersion versionWithString:@""], @"");
    XCTAssertNil([NWVersion versionWithString:@"v1.0"], @"");
}

- (void)testComponentLength
{
    XCTAssertEqual([[NWVersion versionWithString:@"1.1"] length], (NSUInteger)2, @"");
}

- (void)testRangeException
{
    NWVersion *v = [NWVersion versionWithString:@"1.1"];
    XCTAssertThrows([v componentAtIndex:2], @"");
}

- (void)testComponentAccess
{
    NWVersion *v = [NWVersion versionWithString:@"1.2.3.4"];
    XCTAssertEqual([v componentAtIndex:0], (NSInteger)1, @"");
    XCTAssertEqual([v componentAtIndex:1], (NSInteger)2, @"");
    XCTAssertEqual([v componentAtIndex:2], (NSInteger)3, @"");
    XCTAssertEqual([v componentAtIndex:3], (NSInteger)4, @"");
}

@end
