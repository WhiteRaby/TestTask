//
//  ServerManager.h
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager*)manager;

- (void)getMoviesWithCompletion:(void (^)(NSMutableArray *movies))completion;
- (void) getContentSizeOfURL:(NSString*) URL
              withCompletion:(void (^)(NSError *error, long long contentSize))completion;

- (NSURLSessionDownloadTask*)getMovieWithURL:(NSString*)stringURL
                                    progress:(void (^)(NSProgress *downloadProgress))progress
                                  completion:(void (^)())completion;

- (void)resumeDownloadForTask:(NSURLSessionDownloadTask*)downloadTask;
- (void)pauseDownloadForTask:(NSURLSessionDownloadTask*)downloadTask;
- (BOOL)removeFileForTask:(NSURLSessionDownloadTask*)downloadTask;

@end
