//
//  DownloadedItemCell.m
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "DownloadedItemCell.h"
#import "MovieEntity.h"
#import "NSString+TestTask.h"

@implementation DownloadedItemCell

- (void)configureCellWithMovie:(MovieEntity*)movie {
    
    self.titleLabel.text = [movie title];
    if (movie.totalBytes) {
        self.sizeLabel.text = [NSString stringWithFormat:@"(%@)", [NSString formatedStringOfBytes:movie.totalBytes]];
    } else {
        self.sizeLabel.text = @"";
    }
    [self.progressView setProgress:movie.fractionCompleted];
    if (movie.status != MovieStatusReady) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ %@ of %@ (%d%%)",
                                 [NSString stringForMovieStatus:movie.status],
                                 [NSString formatedStringOfBytes:movie.completedBytes],
                                 [NSString formatedStringOfBytes:movie.totalBytes],
                                 (int)(movie.fractionCompleted * 100)];
    } else {
        self.statusLabel.text = @" ";
    }
    [self.downloadButton setTitle:[NSString buttonTitleForMovieStatus:movie.status] forState:UIControlStateNormal];
}

@end
