//
//  NSString+TestTask.m
//  TestTask
//
//  Created by Alexandr on 19.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "NSString+TestTask.h"

@implementation NSString (TestTask)

+ (NSString*)formatedStringOfBytes:(long long)bytes {
    
    NSString *suffix = @"B";
    
    if (bytes >= 1024) {
        bytes /= 1024;
        suffix = @"KB";
    }
    if (bytes >= 1024) {
        bytes /= 1024;
        suffix = @"MB";
    }
    if (bytes >= 1024) {
        bytes /= 1024;
        suffix = @"GB";
    }
    
    return [NSString stringWithFormat:@"%lld %@", bytes, suffix];
}

+ (NSString*)buttonTitleForMovieStatus:(MovieStatus)movieStatus {
    
    NSArray *statuses = @[
                          @"Download",
                          @"Pause",
                          @"Resume",
                          @"Remove"
                          ];
    
    return statuses[movieStatus];
}

+ (NSString*)stringForMovieStatus:(MovieStatus)movieStatus {
    
    NSArray *statuses = @[
                          @"Ready",
                          @"Downloading",
                          @"Paused",
                          @"Completed"
                          ];
    
    return statuses[movieStatus];
}

@end
