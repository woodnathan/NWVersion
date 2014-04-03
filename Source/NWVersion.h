//
//  NWVersion.h
//  Squadio
//
//  Created by Nathan Wood on 2/04/2014.
//  Copyright (c) 2014 Appening. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A simple class to help with version strings of abitrary length
 */
@interface NWVersion : NSObject {
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
 *  Gets the component at the specified index
 *
 *  @param index The index of the component to get
 *
 *  @return The value at the index
 */
- (NSInteger)componentAtIndex:(NSUInteger)index;
- (NSNumber *)objectAtIndexedSubscript:(NSUInteger)idx;

@end
