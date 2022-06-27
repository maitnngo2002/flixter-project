//
//  TrailerViewController.m
//  Flixter
//
//  Created by Mai Ngo on 6/17/22.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerView;
@property (weak, nonatomic) IBOutlet UIButton *goBack;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    id tID = self.movie[@"id"];
    
    NSString *trailerID = [tID stringValue];
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    
    NSString *idTrailerURLString = [baseURLString stringByAppendingString:trailerID];
    
    NSString *fullTrailerURLString = [idTrailerURLString stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    
    NSURL *url = [NSURL URLWithString:fullTrailerURLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies" message:@"The Internet connection seems to be offline." preferredStyle:(UIAlertControllerStyleAlert)];

            [self presentViewController:alert animated:YES completion:^{
            }];
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *trailerDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *trailers = trailerDictionary[@"results"][0];
            NSString *trailerKey = trailers[@"key"];
            NSString *youtubeLink = @"https://www.youtube.com/watch?v=";
            NSString *fullYoutubeLink = [youtubeLink stringByAppendingString:trailerKey];
            NSURL *videoURL = [NSURL URLWithString:fullYoutubeLink];
            NSURLRequest *request = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.trailerView loadRequest:request];
        }
    }];
    [task resume];
}

- (IBAction)onGoBackTap:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^(void){NSLog(@"See you");}];
    
}


@end
