//
//  NSData+Base64.h
//  Kitaplik
//
//  Created by Engin Kurutepe on 27.08.10.
//  Copyright 2010 Fifteen Jugglers Software. All rights reserved.
//

@interface NSData (Base64) 

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(unsigned int) lineLength;

@end
