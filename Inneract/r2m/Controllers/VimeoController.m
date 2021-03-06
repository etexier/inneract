//
//  VimeoController.m
//
//  File generated by Magnet rest2mobile 1.1 - Mar 18, 2015 3:03:18 PM
//  @See Also: http://developer.magnet.com
//
#import "VimeoController.h"

@implementation VimeoController

+ (NSDictionary *)metaData {

    NSMutableDictionary *controllerMetaData = [NSMutableDictionary dictionary];

    MMControllerMethod *method;
    //controller schema for interface VimeoController

    //controller schema for controller method getVimeoVideoConfig
    method = [MMControllerMethod new];
    method.name = @"getVimeoVideoConfig";
    method.path = @"video/{id}/config";
    method.baseURL = [NSURL URLWithString:@"https://player.vimeo.com"];
    method.method = @"GET";
    method.produces = [NSSet setWithObjects:@"application/json", nil];

    NSMutableArray *vimeoControllerGetVimeoVideoConfigParams = [NSMutableArray new];
    MMControllerParam *vimeoControllerGetVimeoVideoConfigMagnetId = [MMControllerParam new];
    vimeoControllerGetVimeoVideoConfigMagnetId.name = @"id";
    vimeoControllerGetVimeoVideoConfigMagnetId.style = @"TEMPLATE";
    vimeoControllerGetVimeoVideoConfigMagnetId.type = @"NSString *";
    vimeoControllerGetVimeoVideoConfigMagnetId.optional = @NO;
    [vimeoControllerGetVimeoVideoConfigParams addObject:vimeoControllerGetVimeoVideoConfigMagnetId];

    method.parameters = [vimeoControllerGetVimeoVideoConfigParams copy];
    method.returnType = @"_bean:VimeoVideoConfigResult";
    [controllerMetaData setObject:method forKey:@"VimeoController:getVimeoVideoConfig"];


    return [controllerMetaData copy];
}

@end
