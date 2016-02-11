//
//  FISViewController.m
//  zenGarden
//
//  Created by Ken M. Haggerty on 2/11/16.
//  Copyright © 2016 The Flatiron School. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *shrub;
@property (nonatomic, strong) IBOutlet UIImageView *swordInRock;
@property (nonatomic, strong) IBOutlet UIImageView *rake;
@property (nonatomic, strong) IBOutlet UIImageView *rock;
@property (nonatomic) CGPoint shrubLocation;
@property (nonatomic) CGPoint swordInRockLocation;
@property (nonatomic) CGPoint rakeLocation;
@property (nonatomic) CGPoint rockLocation;
@end

@implementation FISViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.shrub addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewWasDragged:)]];
    [self.swordInRock addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewWasDragged:)]];
    [self.rake addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewWasDragged:)]];
    [self.rock addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewWasDragged:)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setShrubLocation:self.shrub.center];
    [self setSwordInRockLocation:self.swordInRock.center];
    [self setRakeLocation:self.rake.center];
    [self setRockLocation:self.rock.center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imageViewWasDragged:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIImageView *imageView = (UIImageView *)panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([imageView isEqual:self.shrub]) [self setShrubLocation:imageView.center];
        else if ([imageView isEqual:self.swordInRock]) [self setSwordInRockLocation:imageView.center];
        else if ([imageView isEqual:self.rake]) [self setRakeLocation:imageView.center];
        else if ([imageView isEqual:self.rock]) [self setRockLocation:imageView.center];
        return;
    }
    
    CGPoint delta = [panGestureRecognizer translationInView:imageView.superview];
    if ([imageView isEqual:self.shrub]) [self.shrub setCenter:CGPointMake(self.shrubLocation.x+delta.x, self.shrubLocation.y+delta.y)];
    else if ([imageView isEqual:self.swordInRock]) [self.swordInRock setCenter:CGPointMake(self.swordInRockLocation.x+delta.x, self.swordInRockLocation.y+delta.y)];
    else if ([imageView isEqual:self.rake]) [self.rake setCenter:CGPointMake(self.rakeLocation.x+delta.x, self.rakeLocation.y+delta.y)];
    else if ([imageView isEqual:self.rock]) [self.rock setCenter:CGPointMake(self.rockLocation.x+delta.x, self.rockLocation.y+delta.y)];
    
    if ((panGestureRecognizer.state == UIGestureRecognizerStateEnded) || (panGestureRecognizer.state == UIGestureRecognizerStateCancelled) || (panGestureRecognizer.state == UIGestureRecognizerStateFailed))
    {
        [UIView animateWithDuration:0.18f animations:^{
            [self ensureImageViewIsNotOffScreen:imageView];
        } completion:^(BOOL finished) {
            [self checkForWin];
        }];
    }
}

- (void)checkForWin
{
    if (self.swordInRock.center.x >= self.swordInRock.superview.bounds.size.width*0.5f) return;
    
    if (hypotf((float)(self.shrub.center.x-self.rake.center.x), (float)(self.shrub.center.y-self.rake.center.y)) > 100.0f) return;
    
    if (roundf((float)(self.rock.center.y/self.rock.superview.bounds.size.height)) == roundf((float)(self.swordInRock.center.y/self.swordInRock.superview.bounds.size.height))) return;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You win!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *imageViews = @[self.shrub, self.swordInRock, self.rake, self.rock];
    for (UIImageView *imageView in imageViews)
    {
        [imageView setCenter:CGPointMake(imageView.superview.bounds.size.width*arc4random_uniform(INT_MAX)/(INT_MAX-1), imageView.superview.bounds.size.height*arc4random_uniform(INT_MAX)/(INT_MAX-1))];
        [self ensureImageViewIsNotOffScreen:imageView];
    }
}

- (void)ensureImageViewIsNotOffScreen:(UIImageView *)imageView
{
    [imageView setCenter:CGPointMake(fmaxf((float)imageView.center.x, (float)imageView.frame.size.width*0.5f), fmaxf((float)imageView.center.y, (float)imageView.frame.size.height*0.5f))];
    [imageView setCenter:CGPointMake(fminf((float)imageView.center.x, (float)(imageView.superview.bounds.size.width-imageView.frame.size.width*0.5f)), fminf((float)imageView.center.y, (float)(imageView.superview.bounds.size.height-imageView.frame.size.height*0.5f)))];
}

@end
