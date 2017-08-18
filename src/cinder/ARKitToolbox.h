//
//  NSObject+ARKitToolbox.h
//  Thumper
//
//  Created by Joseph Chow on 8/17/17.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#include "ARProcessor.h"

class ARToolbox {
    ARRef processor;
public:
    ARToolbox();
    void setup();
};
