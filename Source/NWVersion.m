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

@end
