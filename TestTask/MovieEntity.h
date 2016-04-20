//
//  MovieEntity.h
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MovieStatus) {
    MovieStatusReady = 0,
    MovieStatusDownloading,
    MovieStatusPaused,
    MovieStatusCompleted
};

@class NSURLSessionDownloadTask;


@protocol MovieEntityDelegate;


@interface MovieEntity : NSObject

@property (weak, nonatomic) id<MovieEntityDelegate> delegate;

@property (nonatomic) NSInteger ID;
@property (strong, nonatomic) NSString *downloadURL;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) long long totalBytes;
@property (nonatomic) long long completedBytes;
@property (nonatomic) double fractionCompleted;
@property (nonatomic) MovieStatus status;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadMovieTask;

- (instancetype)initWithID:(NSInteger)ID URL:(NSString*)URL title:(NSString*)title;
- (void)setupMovie;
- (void)buttonClicked;

@end


@protocol MovieEntityDelegate <NSObject>
- (void)movieDidUpdate:(MovieEntity *)movie;
- (void)movieDeleted:(MovieEntity *)movie;
@end