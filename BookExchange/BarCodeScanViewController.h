//
//  igViewController.h
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanProtocol <NSObject>

- (void)updateScanner:(NSString *)isbn;

@end

@interface BarCodeScanViewController : UIViewController

@property id<ScanProtocol> delegate;

@end