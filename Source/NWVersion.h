//
//  NWVersion.h
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

#import <Foundation/Foundation.h>

/**
 *  A simple class to help with version strings of abitrary length
 */
@interface NWVersion : NSObject <NSCopying> {
  @private
    NSUInteger _size; // The length of the components array
    NSInteger *_components; // An array of each component
}

/**
 *  Allocates and initializes a new NWVersion object with the provided string
 *  The parser asserts that read values do not under or overflow
 *
 *  @param string A valid version string like "1.0.0" or "0.1.0.1"
 *
 *  @return the new object, or nil if the string was invalid
 */
+ (instancetype)versionWithString:(NSString *)string;

/**
 *  Initializes a new NWVersion object with the provided string
 *  The parser asserts that read values do not under or overflow
 *
 *  @param string A valid version string like "1.0.0" or "0.1.0.1"
 *
 *  @return the new object, or nil if the string was invalid
 */
- (instancetype)initWithString:(NSString *)string;

/**
 *  The length of the version object in number of components
 *  A version string of "1.0.0.0" has a length of 4
 */
@property (nonatomic, readonly) NSUInteger length;

/**
 *  Produces a string representation of the version object
 *
 *  @return A version string
 */
- (NSString *)stringValue;

/**
 *  Gets the component at the specified index
 *
 *  @param index The index of the component to get
 *
 *  @return The value at the index
 */
- (NSInteger)componentAtIndex:(NSUInteger)index;

/**
 *  Gets the component at the specified index
 *
 *  @param index The index of the component to get
 *
 *  @return An NSNumber of the value at the index
 */
- (NSNumber *)objectAtIndexedSubscript:(NSUInteger)idx;

/**
 *  Returns an NSComparisonResult value that indicates whether the
 *  receiver is greater than, equal to, or less than a given version object.
 *
 *  @param version The number with which to compare the receiver.
 *                 This value must not be nil. If the value is nil, the behavior
 *                 is undefined and may change in the future.
 *
 *  @return NSOrderedAscending if the value of version is greater than the receiver’s, NSOrderedSame if they’re equal, and NSOrderedDescending if the value of version is less than the receiver’s.
 */
- (NSComparisonResult)compare:(NWVersion *)version;

/**
 *  Returns a Boolean value that indicates whether the receiver and a given version are equal.
 *
 *  @param version The version with which to compare the receiver.
 *
 *  @return YES if the receiver and version are equal, otherwise NO.
 */
- (BOOL)isEqualToVersion:(NWVersion *)version;

@end
