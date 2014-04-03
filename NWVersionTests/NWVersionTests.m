//
//  NWVersionTests.m
//
//  Copyright (c) 2014 Nathan Wood (http://www.woodnathan.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

- (void)testValidEquality
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0"];
    
    XCTAssertTrue([v1 isEqual:v2], @"");
    XCTAssertTrue([v1 isEqualToVersion:v2], @"");
}

- (void)testValidInequality
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0.0"];
    
    XCTAssertFalse([v1 isEqual:v2], @"");
    XCTAssertFalse([v1 isEqualToVersion:v2], @"");
}

- (void)testNilEquality
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    
    XCTAssertFalse([v1 isEqual:nil], @"");
    XCTAssertFalse([v1 isEqualToVersion:nil], @"");
}

- (void)testHashing
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v3 = [NWVersion versionWithString:@"1.0"];
    
    XCTAssertEqual([v1 hash], [v2 hash], @"");
    XCTAssertNotEqual([v2 hash], [v3 hash], @"");
}

- (void)testCopying
{
    NWVersion *v1 = [NWVersion versionWithString:@"2.0"];
    NWVersion *v2 = [v1 copy];
    
    XCTAssertNotEqual(v1, v2, @"");
    XCTAssertTrue([v1 isEqualToVersion:v2], @"");
    XCTAssertEqualObjects(v1, v2, @"");
}

@end
