//
//  NSString+TestTask.h
//  TestTask
//
//  Created by Alexandr on 19.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MovieStatus);

@interface NSString (TestTask)

+ (NSString*)formatedStringOfBytes:(long long)bytes;
+ (NSString*)buttonTitleForMovieStatus:(MovieStatus)movieStatus;
+ (NSString*)stringForMovieStatus:(MovieStatus)movieStatus;

@end
