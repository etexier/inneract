//
//  UIImageView+IP.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/15/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "UIImage+WebP.h"
#import "UIImageView+IP.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (IP)

- (void)setImageFromWebPURL:(NSURL *)url completion:(void (^)(UIImage *img))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithWebPData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completion(img);
        });
    });

}

- (void)ip_setImageWithURL:(NSURL *)url {

    if ([[url absoluteString] hasSuffix:@".webp"]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:request];
        if (cachedImage) {
            self.image = cachedImage;
            return;
        }

        __weak __typeof(self)weakSelf = self;
        [self setImageFromWebPURL:url completion:^(UIImage *img) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.image = img;
            [[[strongSelf class] sharedImageCache] cacheImage:img forRequest:request];
            
        }];
        return;
    }

    [self setImageWithURL:url];
}


@end
