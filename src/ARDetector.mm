//
//  ARDetector.m
//  arkit-example
//
//  Created by Adam Ferriss on 7/1/18.
//

#include "ARDetector.h"
#include "ofxiOS.h"
using namespace std;
using namespace ARCommon;

namespace ARCore {
    ARDetector::ARDetector(ARSession * session){
        this->session = session;
    }
    
    void ARDetector::createScan(string name, matrix_float4x4 transform, ofVec3f centerPt, ofVec3f size){
        ARConfiguration * config = session.configuration;
        
        // make sure wer're in a scanning config
        if([config isKindOfClass:[ARObjectScanningConfiguration class]]){
            
            // convert the vec3s to simd
            simd_float3 simCenter = ARCommon::toSIMDFloat3(centerPt);
            simd_float3 simExtent = ARCommon::toSIMDFloat3(size);
            
            // this method creates the reference object
            // the completion handler will save the reference object if saveToDevice is true, otherwise we should just give back ref in this session
            [session createReferenceObjectWithTransform:transform center:simCenter extent:simExtent completionHandler:^(ARReferenceObject * referenceObj, NSError * err){
                
                if(!err){
                    NSString * nsname = [NSString stringWithCString:name.c_str() encoding:[NSString defaultCStringEncoding]];
                    addReferenceObject(nsname, referenceObj, createScreenshot());
                } else {
                    NSLog(@"Error creating the reference object: %@", [err localizedDescription]);
                }
                
            }];
        }
    }
    
    UIImage * ARDetector::createScreenshot(){
        
        // pixel buffer is in frame.capturedImage
        ARFrame *frame = session.currentFrame;
        
        // from https://stackoverflow.com/questions/8072208/how-to-turn-a-cvpixelbuffer-into-a-uiimage
        CIImage * ciimage = [CIImage imageWithCVPixelBuffer:frame.capturedImage];
        CIContext *tempCtx = [CIContext contextWithOptions:nil];
        CGImageRef imgRef = [tempCtx createCGImage:ciimage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(frame.capturedImage), CVPixelBufferGetHeight(frame.capturedImage))];
        
        UIImage * uiImg = [UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
        
        return uiImg;
    }

    // All we're doing here is getting the url to the documents directory of the app and saving the model there.
    // The save function also requires a screenshot as a UIImage
    void ARDetector::saveScan(ScannedObject scan){
        NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL * documentsURL = [paths lastObject];
        NSString * extension = @".arobject";
        NSString * filename = [scan.name stringByAppendingString:extension];
        NSURL * finalURL = [documentsURL URLByAppendingPathComponent: filename];
        
        NSError * saveErr = nil;
        bool saveReferenceObject = [scan.referenceObject exportObjectToURL:finalURL previewImage:scan.screenshot error: &saveErr];
        
        if(!saveReferenceObject){
            NSLog(@"Error saving the reference obj: %@", [saveErr localizedDescription]);
        }
    }
    
    // TODO
    void ARDetector::loadScan(){
        
    }
    
    void ARDetector::addReferenceObject(NSString * name, ARReferenceObject * obj, UIImage * screenshot){
        ScannedObject scan;
        scan.referenceObject = obj;
        scan.screenshot = screenshot;
        scan.name = name;
        
        simd_float3 c = obj.center;
        simd_float3 e = obj.extent;
        simd_float3 s = obj.scale;
        
        scan.center = ARCommon::toOfVec3f(c);
        scan.extent = ARCommon::toOfVec3f(e);
        scan.scale = ARCommon::toOfVec3f(s);
        
        scans.push_back(scan);
    }
    
    
    
}
