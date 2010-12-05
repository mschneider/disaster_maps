//
//  NSString+Hex.m
//  Kitaplik
//
//  Created by Engin Kurutepe on 9/7/10.
//  Copyright 2010 Fifteen Jugglers Software. All rights reserved.
//

#import "NSString+Hex.h"

unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}



@implementation NSString (NSStringExtensions)

- (NSData *) decodeFromHexidecimal;
{
    const char * bytes = [self cStringUsingEncoding: NSUTF8StringEncoding];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;
	
    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
	
    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);
	
    return result;
}

@end