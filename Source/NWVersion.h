//
//  NWVersion.h
//  Squadio
//
//  Created by Nathan Wood on 2/04/2014.
//  Copyright (c) 2014 Appening. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWVersion : NSObject {
  @private
    NSUInteger _size;
    NSInteger *_components;
}

+ (instancetype)versionWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

@property (nonatomic, readonly) NSUInteger length;

- (NSInteger)componentAtIndex:(NSUInteger)index;

@end
