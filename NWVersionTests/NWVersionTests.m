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

@end
