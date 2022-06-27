//
//  MoviesGridViewController.m
//  Flixter
//
//  Created by Mai Ngo on 6/16/22.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property(strong, nonatomic) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISearchBar *movieSearch;
@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.movieSearch.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
}
- (void)fetchMovies{
    NSURL *const url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *const request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *const session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *const task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot access movies" message:@"There doesn't seem to be a stable Internet connection." preferredStyle:(UIAlertControllerStyleAlert)];
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self fetchMovies];
            }];
            // create a CANCEL action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            // add the CANCEL action to the alert controller
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            self.movies = dataDictionary[@"results"];
            
            self.filteredData = self.movies;
            
            [self.collectionView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    MovieCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *const baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *const posterURLString = movie[@"poster_path"];
    
    NSString *const fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *const posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.data filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredData = self.data;
    }
    [self.collectionView reloadData];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.movieSearch.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.movieSearch.showsCancelButton = NO;
    self.movieSearch.text = @"";
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    [self.movieSearch resignFirstResponder];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UICollectionViewCell * tappedCell = sender;
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:tappedCell];
    
    NSDictionary * movie = self.filteredData[indexPath.item];
    
    DetailsViewController * detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end
