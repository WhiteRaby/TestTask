//
//  ServerManager.m
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking.h>
#import "MovieEntity.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation ServerManager

+ (ServerManager*)manager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getMoviesWithCompletion:(void (^)(NSMutableArray *movies))completion {
    
    NSString *baseURL = @"https://devimages.apple.com.edgekey.net/wwdc-services/ftzj8e4h/6rsxhod7fvdtnjnmgsun/videos.json";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    [manager GET:baseURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {

        NSMutableArray *movies = [NSMutableArray array];
        
        NSInteger ID = 0;
        for (NSDictionary *dict in responseObject[@"sessions"]) {
            
            if (dict[@"download_sd"] != [NSNull null]) {
                MovieEntity *movie = [[MovieEntity alloc] initWithID:ID++
                                                                 URL:dict[@"download_sd"]
                                                               title:dict[@"title"]];
                [movie setupMovie];
                [movies addObject:movie];
            }
        }
        
        if (completion) {
            completion(movies);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) getContentSizeOfURL:(NSString*) URL withCompletion:(void (^)(NSError *error, long long contentSize))completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager HEAD:URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        if (completion) {
            completion(nil, task.response.expectedContentLength);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(error, 0);
        }
    }];
}

- (NSURLSessionDownloadTask*)getMovieWithURL:(NSString*)stringURL
                                    progress:(void (^)(NSProgress *downloadProgress))progress
                                  completion:(void (^)())completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"File wasn't downloaded! Error = %@\n", error);
        } else {
            NSLog(@"File downloaded to: %@\n", filePath);
        }
        
        if (completion) {
            completion();
        }
    }];
    
    return downloadTask;
}

- (void)resumeDownloadForTask:(NSURLSessionDownloadTask*)downloadTask {
    [downloadTask resume];
}

- (void)pauseDownloadForTask:(NSURLSessionDownloadTask*)downloadTask {
    [downloadTask suspend];
}

- (BOOL)removeFileForTask:(NSURLSessionDownloadTask*)downloadTask {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[downloadTask.response suggestedFilename]];
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    return success;
}

@end
