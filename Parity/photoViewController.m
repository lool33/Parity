//
//  photoViewController.m
//  Parity
//
//  Created by Laurent GAIDON on 01/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "photoViewController.h"
#import "FlickrFetcher.h"
#import "helperFlickrData.h"
#import "cachePhoto.h"

@interface photoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)UIBarButtonItem *photoInSetButton;
@property(nonatomic,strong)UIBarButtonItem *formatButton;


@end




@implementation photoViewController

@synthesize photo = _photo;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize spinner = _spinner;

@synthesize formatButton = _formatButton;
@synthesize photoInSetButton = _photoInSetButton;


-(void)setFormatButton:(UIBarButtonItem *)formatButton
{
    
    if(formatButton != _formatButton)
    {
        _formatButton = formatButton;
        NSArray *buttons = [NSArray arrayWithObjects:_formatButton,self.photoInSetButton, nil];
        self.navigationItem.rightBarButtonItems = buttons;
    }
    
}



-(UIBarButtonItem *)formatButton
{
    if(!_formatButton)
    {
        _formatButton = [[UIBarButtonItem alloc]initWithTitle:@"Game's Icon format"
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(changePhotoFormat)];
    }    
    
    return _formatButton;
}


-(void)setPhotoInSetButton:(UIBarButtonItem *)photoInSetButton
{
    
   // if(photoInSetButton != _photoInSetButton)
    //{
        _photoInSetButton = photoInSetButton;
        NSArray *buttons = [NSArray arrayWithObjects:self.formatButton,_photoInSetButton, nil];
        self.navigationItem.rightBarButtonItems = buttons;
    //}
    
}


-(UIBarButtonItem *)photoInSetButton
{

    if(!_photoInSetButton)
    {
        
        
    _photoInSetButton = [[UIBarButtonItem alloc]initWithTitle:@"Add to a set"
                                                        style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(ShowModalSetController)];
    }
    
    
    return _photoInSetButton;
}


-(void)ShowModalSetController
{
    
    /*
     Code not usefull
     Here we should just check from where is coming the photo
     If it's coming from flickr then set the button title as "Add to a set"
     If it's coming from coredata then set the button title as "Remove from set"
     
    if(self.photoInSetButton.style == UIBarButtonSystemItemAdd)
    {
        UIBarButtonItem *button = self.photoInSetButton;
        [button setStyle:UIBarButtonSystemItemCancel];
        [self setPhotoInSetButton:button];
    
        //here call to add the photo process
        
        
    }else if (self.photoInSetButton.style == UIBarButtonSystemItemCancel)
    {
        UIBarButtonItem *button = self.photoInSetButton;
        [button setStyle:UIBarButtonSystemItemAdd];
        [self setPhotoInSetButton:button];
    }
    
    */
    NSLog(@"Here we have to code the remove and add the photo from/to the set process");
    //this process add/remove should be done by the modal controller displayed
}



-(void)changePhotoFormat
{

    if([self.formatButton.title isEqualToString:@"Large Flickr Format"])
    {
        
        //here reload a full size photo
        self.formatButton.title = @"Game's Icon format";
        [self loadPhotoWithFlickrFormat:FlickrPhotoFormatLarge];
        
        
    }else if ([self.formatButton.title isEqualToString:@"Game's Icon format"])
    {
        [self loadPhotoWithFlickrFormat:FlickrPhotoFormatSquare];
        
                
    
        //here change the photo size and reload it with icon size
        self.formatButton.title = @"Large Flickr Format";
    }
    
    
}



-(void)loadPhotoWithFlickrFormat:(FlickrPhotoFormat)format
{
    NSString *title = @"Photo";
    NSString *photoID;
    
    if (self.photo)
    {
        title = [helperFlickrData titleForPhoto:self.photo];
        photoID = [self.photo objectForKey:FLICKR_PHOTO_ID];
        
    }
    
    //update the add or remove button
    
    if(self.photoInSetButton.style == UIBarButtonSystemItemAdd){
        self.photoInSetButton.style = UIBarButtonSystemItemCancel;
        
    }else{
        self.photoInSetButton.style = UIBarButtonSystemItemAdd;
        
    }
    
    
    if(self.imageView.window) self.spinner.alpha = 1;
    
    if (self.photo) [self.spinner startAnimating];
    
    //get the photo from flickr or cache memory if present
    
    dispatch_queue_t downloadQ = dispatch_queue_create("photoLoader", nil);
    dispatch_async(downloadQ, ^{
        //check for the photo is in cache
        
        cachePhoto *cache = [cachePhoto cacheFor:@"photos"];
        
        NSURL *cacheURL = [cache urlForCachedPhotoID:photoID format:format];
               
        
        
        if(!cacheURL)
        {
            cacheURL = [FlickrFetcher urlForPhoto:self.photo format:format];

        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:cacheURL];
        
        
        //Now that we have the image (coming from anywhere, don't care), we save it into the cache memory if it's doesn't already in
        [cache cacheData:imageData ofPhotoID:photoID format:FlickrPhotoFormatLarge];
        
        //here should check for self.imageView.Window and a lot of stuff like for the photo exist and so to dispathc to the main queue but here we dispatch directly
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            //here there is another call to write the photo in the cahce but should not be necessary as it's done previously in the GCD
            //[cache cacheData:imageData ofPhoto:self.photo format:FlickrPhotoFormatLarge];
            
            //set the image in the UIimageView
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0,image.size.width,image.size.height);
            
            //configure the scrollView accordingly to the photo
            self.scrollView.contentSize = image.size;
            self.scrollView.minimumZoomScale = 0.1;
            self.scrollView.maximumZoomScale = 10;
            self.scrollView.zoomScale = 1;
            
                        
               
            //set the scrollView zoomScale to fit the image in width or heigt for a flickrFormatLarge
                
            if(format == FlickrPhotoFormatLarge){
                
                double wScale = self.scrollView.bounds.size.width / image.size.width;
                double hScale = self.scrollView.bounds.size.height / image.size.height;
                if (wScale > hScale) self.scrollView.zoomScale = wScale;
                else self.scrollView.zoomScale = hScale;

            }else if(format == FlickrPhotoFormatSquare){
                
                // set the scrollView to show more than the photo
                
                //calculation of icon frame to be the center of the screen
                CGPoint centerView;
                centerView.x = (self.view.frame.size.width / 2) - (self.imageView.frame.size.width / 2);
                centerView.y = (self.view.frame.size.height / 2) - (self.imageView.frame.size.height / 2);
                
                
                CGRect iconFrame = CGRectMake(centerView.x, centerView.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
                CGRect scrollFrame = CGRectMake(0, 0, 250, 300);
                
                
                [self.imageView setFrame:iconFrame];
                UIViewAutoresizing resize = UIViewAutoresizingFlexibleTopMargin & UIViewAutoresizingFlexibleLeftMargin;
                
                [self.imageView setAutoresizingMask:resize];
                [self.scrollView scrollRectToVisible:scrollFrame animated:NO];

            }
                
                        
            [self.spinner stopAnimating];
            self.spinner.alpha = 0;
            
            [self.imageView setNeedsDisplay];
        
            
        });
        
        
    });
    
    //  dispatch_release(downloadQ);
}



-(void)setPhoto:(NSDictionary *)photo
{
    
    if(photo != _photo)
    {
        _photo = photo;
        if(self.imageView.window) [self loadPhotoWithFlickrFormat:FlickrPhotoFormatLarge];
        
        //here should be managed some NSuserDefault saving to keep trace of the most recent viewed photo
        
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
   
  //  NSLog(@"the height of the image view is : %f and the width is : %f",self.imageView.frame.size.height,self.imageView.frame.size.width);
              
    return self.imageView;
    
}


#pragma mark - View LifeCycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scrollView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self loadPhotoWithFlickrFormat:FlickrPhotoFormatLarge];
    
    self.titleLabel.text = [helperFlickrData titleForPhoto:self.photo];
    self.titleLabel.alpha = 0.8;
    
    NSArray *buttons = [NSArray arrayWithObjects:self.formatButton,self.photoInSetButton, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //regarding to autorotation we have to fix the view of the square format image in landscape mode
    return YES;
}


@end
