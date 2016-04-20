//
//  MovieEntity.m
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "MovieEntity.h"
#import "ServerManager.h"

@implementation MovieEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.status = MovieStatusReady;
        self.totalBytes = 0;
        self.completedBytes = 0;
        self.fractionCompleted = 0.f;
    }
    return self;
}

- (instancetype)initWithID:(NSInteger)ID URL:(NSString*)URL title:(NSString*)title;
{
    self = [self init];
    if (self) {
        self.ID = ID;
        self.downloadURL = URL;
        self.title = title;
    }
    return self;
}

- (void)setupMovie {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[ServerManager manager] getContentSizeOfURL:self.downloadURL withCompletion:^(NSError *error, long long contentSize) {
            self.totalBytes = contentSize;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate movieDidUpdate:self];
            });
        }];
    });
    
    self.downloadMovieTask = [[ServerManager manager] getMovieWithURL:self.downloadURL progress:^(NSProgress *downloadProgress) {
        self.totalBytes = downloadProgress.totalUnitCount;
        self.completedBytes = downloadProgress.completedUnitCount;
        self.fractionCompleted = downloadProgress.fractionCompleted;
        
        static int tick = 0;
        if (tick++ > 33) { // 'cause I want :] , and I know that it's a KOCTbIJIb
            tick = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate movieDidUpdate:self];
                
            });        }
    } completion:^{
        self.status = MovieStatusCompleted;
        [self.delegate movieDidUpdate:self];
        
    }];
}

- (void)buttonClicked {
    
    switch (self.status) {
        case MovieStatusReady:
        case MovieStatusPaused:
            [[ServerManager manager] resumeDownloadForTask:self.downloadMovieTask];
            self.status = MovieStatusDownloading;
            [self.delegate movieDidUpdate:self];
            break;
            
        case MovieStatusDownloading:
            [[ServerManager manager] pauseDownloadForTask:self.downloadMovieTask];
            self.status = MovieStatusPaused;
            [self.delegate movieDidUpdate:self];
            break;
            
        case MovieStatusCompleted:
            if (![[ServerManager manager] removeFileForTask:self.downloadMovieTask]) {
                NSLog(@"Could not delete file!");
            }
            [self.delegate movieDeleted:self];
            break;
    }
    
}

@end
