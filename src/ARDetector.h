//
//  ARDetector.h
//  arkit-example
//
//  Created by Adam Ferriss on 7/1/18.
//

#ifndef ARDetector_h
#define ARDetector_h

#include <stdio.h>
#include "ofMain.h"
#include <ARKit/ARKit.h>
#include "ARUtils.h"
#include "ARObjects.h"
using namespace ARObjects;

namespace ARCore {
    
    typedef std::shared_ptr<class ARDetector>ARDetectorRef;
    
    class ARDetector {
        
        ARSession * session;
        
        void addReferenceObject(ARReferenceObject * obj, UIImage * screenshot);
        
    public:
        //! Constructor - pass in ARSession reference
        ARDetector(ARSession * session);
        
        //! Creates a new ARCam reference
        static ARDetectorRef create(ARSession * session){
            return ARDetectorRef(new ARDetector(session));
        }
        
        //! Creates the ARReferenceObject -- only call this once you've fully collected features around your object
        void createScan(matrix_float4x4 transform, ofVec3f center, ofVec3f size);
        
        //! Save the most recent reference object to the app's documents directory
        void saveScan(ScannedObject scan);
        
        //! Loads a model from the device
        void loadScan();
        
        //! Creates a screenshot that is used as part of the ARObjectReference file
        UIImage * createScreenshot();
        
        vector<ScannedObject> scans;
    };
}

#endif /* ARDetector_h */
