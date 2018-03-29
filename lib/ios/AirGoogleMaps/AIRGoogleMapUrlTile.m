//
//  AIRGoogleMapURLTile.m
//  Created by Nick Italiano on 11/5/16.
//

#import "AIRGoogleMapUrlTile.h"

@implementation AIRGoogleMapUrlTile

- (void)setZIndex:(int)zIndex
{
  _zIndex = zIndex;
  _tileLayer.zIndex = zIndex;
}

- (void)setUrlTemplate:(NSString *)urlTemplate
{
  _urlTemplate = urlTemplate;
  _tileLayer = [GMSURLTileLayer tileLayerWithURLConstructor:[self _getTileURLConstructor]];
}

- (GMSTileURLConstructor)_getTileURLConstructor
{
  NSString *urlTemplate = self.urlTemplate;
  NSUInteger *maximumZ = self.maximumZ;
  NSUInteger *minimumZ = self.minimumZ;
  GMSTileURLConstructor urls = ^NSURL* _Nullable (NSUInteger x, NSUInteger y, NSUInteger zoom) {
    NSString *url = urlTemplate;
    url = [url stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat: @"%ld", (long)x]];
    url = [url stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat: @"%ld", (long)y]];
    url = [url stringByReplacingOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat: @"%ld", (long)zoom]];

   if(maximumZ && zoom > maximumZ) {
      return nil;
    }

    if(minimumZ && zoom < minimumZ) {
      return nil;
    }

    return [NSURL URLWithString:url];
  };
  return urls;
}

@end