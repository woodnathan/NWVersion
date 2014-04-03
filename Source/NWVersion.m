//
//  NWVersion.m
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

- (NSString *)stringValue
{
    NSUInteger length = self.length;
    
    NSMutableArray *compValues = [[NSMutableArray alloc] initWithCapacity:length];
    
    NSInteger *comps = self->_components;
    for (NSUInteger i = 0; i < length; i++)
        [compValues addObject:[NSNumber numberWithInteger:comps[i]]];
    
    return [compValues componentsJoinedByString:@"."];
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

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    
    if ([object isKindOfClass:[NWVersion class]] == NO)
        return NO;
    
    return [self isEqualToVersion:object];
}

- (BOOL)isEqualToVersion:(NWVersion *)version
{
    NSUInteger length = self.length;
    if (version == nil || version.length != length)
        return NO;
    
    NSInteger *comps1 = self->_components;
    NSInteger *comps2 = version->_components;
    for (NSUInteger i = 0; i < length; i++)
    {
        if (comps1[i] != comps2[i])
            return NO;
    }
    
    return YES;
}

#pragma mark Identity

- (NSUInteger)hash
{
    // This needs to be looked at more
    // Not a guaranteed hashing method
    // Might be better to pass into an NSIndexPath
    
    NSUInteger prime = 23;
    NSUInteger result = 1;
    
    NSUInteger length = self.length;
    NSInteger *comps = self->_components;
    for (NSUInteger i = 0; i < length; i++)
        result = prime * result + comps[i];
    
    return result;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NWVersion *version = [[self class] allocWithZone:zone];
    
    version->_size = self->_size;
    
    const size_t size = self->_size * sizeof(NSInteger);
    NSInteger *components = malloc(size);
    memcpy(components, self->_components, size);
    version->_components = components;
    
    return version;
}

#pragma mark NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self stringValue] forKey:@"v"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSString *versionString = nil;
    if ([coder respondsToSelector:@selector(decodeObjectOfClass:forKey:)])
        versionString = [coder decodeObjectOfClass:[NSString class] forKey:@"v"];
    else
        versionString = [coder decodeObjectForKey:@"v"];
    return [self initWithString:versionString];
}

@end
