//
//  DetailsViewController.m
//  Flixter
//
//  Created by Mai Ngo on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];

    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    NSString *const baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *const posterURLString = self.movie[@"poster_path"];
    NSString *const fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *const posterURL = [NSURL URLWithString:fullPosterURLString];
    
    [self.posterView setImageWithURL:posterURL];
    
    NSString *const backdropURLString = self.movie[@"backdrop_path"];
    NSString *const fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *const backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    [self.backdropView setImageWithURL:backdropURL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;

}

#pragma mark - Navigation

@end
