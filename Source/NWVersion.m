//
//  NWVersion.m
//  Squadio
//
//  Created by Nathan Wood on 2/04/2014.
//  Copyright (c) 2014 Appening. All rights reserved.
//

#import "NWVersion.h"

static int *NWVersionParse(NSString *string, NSUInteger *size)
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
        int value = 0;
        if ([scanner scanInt:&value] == NO)
            return NULL;
        
        NSCAssert(value != INT_MIN && value != INT_MAX, @"Component in string underflowed/overflowed");
        
        count++;
    }
    
    scanner.scanLocation = 0; // Reset to the beginning
    
    int *components = calloc(count, sizeof(int));
    for (NSUInteger i = 0; i < count; i++)
    {
        [scanner scanInt:&components[i]];
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
        int *components = NWVersionParse(string, &size);
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

@end
