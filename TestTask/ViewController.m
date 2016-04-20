//
//  ViewController.m
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "DownloadedItemCell.h"
#import "ServerManager.h"
#import "MovieEntity.h"

@interface ViewController () <UITableViewDataSource, MovieEntityDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSMutableArray *downloadsQueue;
@property (nonatomic) BOOL allDownloadsEnable;
@property (nonatomic) BOOL allDownloadsCompleted;


- (IBAction)downloadButtonDidClick:(UIButton*)button;
- (IBAction)allDownloadsButtonDidClick:(UIButton*)button;
- (IBAction)segmentControlValueChange:(UISegmentedControl *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = [NSMutableArray array];
    self.downloadsQueue = [NSMutableArray array];
    self.allDownloadsEnable = NO;
    self.allDownloadsCompleted = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70.0;
    
    [[ServerManager manager] getMoviesWithCompletion:^(NSMutableArray *movies) {
        
        self.movies = movies;
        for (MovieEntity *movie in self.movies) {
            movie.delegate = self;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell configureCellWithMovie:[self.movies objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Actions

- (IBAction)downloadButtonDidClick:(UIButton*)button {
    
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    MovieEntity *movie = [self.movies objectAtIndex:indexPath.row];
    [movie buttonClicked];
    
}

- (IBAction)allDownloadsButtonDidClick:(UIButton*)button {
    
    self.allDownloadsEnable = !self.allDownloadsEnable;
    
    while (self.allDownloadsEnable && !self.allDownloadsCompleted && [self.downloadsQueue count] < 2) {
        [self p_updateDownloadQueue];
    }
    
    [self showAlertWithMessage:
     (self.allDownloadsEnable ? @"Start all downloads mode" : @"Stop all downloads mode")];
}

- (IBAction)segmentControlValueChange:(UISegmentedControl *)sender {
    
    NSString *key = nil;
    switch (sender.selectedSegmentIndex) {
        case 0:
            key = @"ID";
            break;
        case 1:
            key = @"totalBytes";
            break;
        case 2:
            key = @"title";
            break;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                 ascending:YES];
    self.movies = [[self.movies sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - DownloadsQueue Methods

- (void)p_updateDownloadQueue {
    
    if (!self.allDownloadsEnable) {
        return;
    }
    
    for (MovieEntity *movie in self.movies) {
        if (movie.status == MovieStatusReady && ![self.downloadsQueue containsObject:movie]) {
            [self.downloadsQueue addObject:movie];
            [movie buttonClicked];
            return;
        }
    }
    self.allDownloadsCompleted = YES;
}

#pragma mark - MovieEntityDelegate

- (void)movieDidUpdate:(MovieEntity*)movie {
    NSUInteger index = [self.movies indexOfObject:movie];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    
    if (movie.status == MovieStatusCompleted && [self.downloadsQueue containsObject:movie]) {
        [self.downloadsQueue removeObject:movie];
        [self p_updateDownloadQueue];
    }
}

- (void)movieDeleted:(MovieEntity *)movie {
    NSUInteger index = [self.movies indexOfObject:movie];
    
    [self.movies removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - Alert

- (void)showAlertWithMessage:(NSString*)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
