//
//  NSObject+ARKitToolbox.m
//  Thumper
//
//  Created by Joseph Chow on 8/17/17.
//

#import "ARKitToolbox.h"


@interface  ARKitController: NSObject
@property (nonatomic, strong) ARSession *session;

- (void) loadARKit;
@end

@implementation ARKitController

- (void) loadARKit {
    self.session = [ARSession new];
    //self.session.delegate = self;
    
    // TODO should be ARWorldTrackingConfiguration now but not in current API(might need to re-download sdk)
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    
    // setup horizontal plane detection
    //configuration.planeDetection = ARPlaneDetectionHorizontal;
    
    [self.session runWithConfiguration:configuration];
}
@end


ARKitController * sToolbox = nil;


ARToolbox::ARToolbox(){
    
}


void ARToolbox::setup(){
    if(sToolbox == nil){
        sToolbox = [[ARKitController alloc] init];
        [sToolbox loadARKit];
        
        processor = ARProcessor::create(sToolbox.session);
        processor->setup();
    }
}
