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

- (void)testSubscriptRangeException
{
    NWVersion *v = [NWVersion versionWithString:@"1.1"];
    XCTAssertThrows(v[2], @"");
}

- (void)testSubscriptComponentAccess
{
    NWVersion *v = [NWVersion versionWithString:@"1.2.3.4"];
    XCTAssertEqualObjects(v[0], @((NSInteger)1), @"");
    XCTAssertEqualObjects(v[1], @((NSInteger)2), @"");
    XCTAssertEqualObjects(v[2], @((NSInteger)3), @"");
    XCTAssertEqualObjects(v[3], @((NSInteger)4), @"");
}

- (void)testOverflow
{
    NSString *vString = @"42949672964294967296.42949672964294967296";
    XCTAssertThrows([NWVersion versionWithString:vString], @"");
}

- (void)testSameComparison
{
    NWVersion *v1 = [NWVersion versionWithString:@"1.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"1.0"];
    
    XCTAssertEqual([v1 compare:v2], NSOrderedSame, @"");
}

- (void)testDescendingEqualLengthComparison
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"1.0"];
    
    XCTAssertEqual([v1 compare:v2], NSOrderedDescending, @"");
}

- (void)testAscendingEqualLengthComparison
{
    NWVersion *v1 = [NWVersion versionWithString:@"1.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0"];
    
    XCTAssertEqual([v1 compare:v2], NSOrderedAscending, @"");
}

- (void)testDescendingVariableLengthComparison
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0.1"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0"];
    
    XCTAssertEqual([v1 compare:v2], NSOrderedDescending, @"");
    
    NWVersion *v3 = [NWVersion versionWithString:@"2.0.0.1"];
    NWVersion *v4 = [NWVersion versionWithString:@"2.0"];
    
    XCTAssertEqual([v3 compare:v4], NSOrderedDescending, @"");
}

- (void)testAscendingVariableLengthComparison
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0.1"];
    
    XCTAssertEqual([v1 compare:v2], NSOrderedAscending, @"");
    
    NWVersion *v3 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v4 = [NWVersion versionWithString:@"2.0.0.1"];
    
    XCTAssertEqual([v3 compare:v4], NSOrderedAscending, @"");
}

- (void)testSameObjectComparison
{
    NWVersion *version = [NWVersion versionWithString:@"2.0"];
    XCTAssertEqual([version compare:version], NSOrderedSame, @"");
}

@end
