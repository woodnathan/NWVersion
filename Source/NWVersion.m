//
//  NWVersion.m
//  Squadio
//
//  Created by Nathan Wood on 2/04/2014.
//  Copyright (c) 2014 Appening. All rights reserved.
//

#import "NWVersion.h"

static NSInteger *NWVersionParse(NSString *string, NSUInteger *size)
{
    string = [string copy];
    if (string.length == 0)
        return NULL;
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"."];
    
    // We count the number of components
    // As well as check for overflow and underflow
    NSUInteger count = 0;
    while ([scanner isAtEnd] == NO)
    {
        NSInteger value = 0;
        if ([scanner scanInteger:&value] == NO)
            return NULL;
        
        NSCAssert(value != NSIntegerMin && value != NSIntegerMax, @"Component in string underflowed/overflowed");
        
        count++;
    }
    
    scanner.scanLocation = 0; // Reset to the beginning
    
    NSInteger *components = calloc(count, sizeof(NSInteger));
    for (NSUInteger i = 0; i < count; i++)
    {
        [scanner scanInteger:&components[i]];
    }
    
    if (size != NULL)
        *size = count;
    
    return components;
}

@implementation NWVersion

+ (instancetype)versionWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self)
    {
        NSUInteger size = 0;
        NSInteger *components = NWVersionParse(string, &size);
        if (components == NULL)
            return nil;
        
        self->_components = components;
        self->_size = size;
    }
    return self;
}

- (void)dealloc
{
    free(self->_components);
}

#pragma mark Accessors

- (NSUInteger)length
{
    return self->_size;
}

- (NSInteger)componentAtIndex:(NSUInteger)index
{
    NSUInteger length = self.length;
    if (index >= length)
        [NSException raise:NSRangeException
                    format:@"*** -[NWVersion componentAtIndex:]: index %lu is beyond bounds [0 .. %lu]", (unsigned long)index, (unsigned long)length];
    
    return self->_components[index];
}

- (NSNumber *)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [NSNumber numberWithInteger:[self componentAtIndex:idx]];
}

#pragma mark Comparison

- (NSComparisonResult)compare:(NWVersion *)version
{
    if (version == nil)
        return NSOrderedDescending;
    else
        if (version == self)
            return NSOrderedSame;
    
    const NSUInteger len1 = self.length;
    const NSUInteger len2 = version.length;
    
    NSInteger *const comps1 = self->_components;
    NSInteger *const comps2 = version->_components;
    
    const NSUInteger len = MIN(len1, len2);
    
    // Walk along the minimum number of components
    //   comparing each component as we go
    for (NSUInteger i = 0; i < len; i++)
    {
        if (comps1[i] < comps2[i])
            return NSOrderedAscending;
        else
            if (comps1[i] > comps2[i])
                return NSOrderedDescending;
    }
    
    // The minimum matching components are equal
    // ie. [@"2.0" compare:@"2.0.1"]
    // If their lengths are equal, and they're
    //   components match, they're comparatively the same
    // Eg. [@"2.0" compare:@"2.0"]
    if (len1 == len2)
        return NSOrderedSame;
    
    // [@"2.0" compare:@"2.0.1"]
    if (len1 < len2)
        return NSOrderedAscending;
    
    // [@"2.0.1" compare:@"2.0"]
    return NSOrderedDescending;
}

@end
