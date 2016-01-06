//
//  ViewController.swift
//  iBeacon Proximity
//
//  Created by Tyler Vick on 1/5/16.
//  Copyright © 2016 Tyler Vick. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let UUID = NSUUID(UUIDString: "89FEAD39-0399-45EA-B8A2-A672E77CD52A")
    let BEACON_IDENTIFIER = "com.tylervick.ibeacon-proximity.iBeacon"
    
    var manager: CLLocationManager = CLLocationManager()
    var stackView: UIStackView?
    var region: CLBeaconRegion?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.manager.respondsToSelector("requestAlwaysAuthorization")) {
            self.manager.requestAlwaysAuthorization()
        }

        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.allowsBackgroundLocationUpdates = true
        
        region = CLBeaconRegion(
            proximityUUID: UUID!,
            identifier: BEACON_IDENTIFIER
        )

        self.manager.startRangingBeaconsInRegion(region!)

        stackView = UIStackView()
        stackView?.axis = .Vertical
        stackView?.distribution = .EqualSpacing
        stackView?.alignment = .Center

        self.view.addSubview(stackView!)

        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.centerXAnchor
            .constraintEqualToAnchor(self.view.centerXAnchor).active = true
        stackView?.centerYAnchor
            .constraintEqualToAnchor(self.view.centerYAnchor).active = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(
        manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        inRegion region: CLBeaconRegion) {

            addBeaconToStack(beacons)

    }

    func addBeaconToStack(beacons: [CLBeacon]) {
        
        stackView?.subviews.forEach({ $0.removeFromSuperview() })

        let superviewWidth = self.view.frame.size.width
        let superviewHeight = self.view.frame.size.height

        for beacon in beacons {
            
            let regionView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: superviewWidth,
                height: superviewHeight / CGFloat(beacons.count))
            )

            regionView.layer.borderWidth = 1

            let label = UILabel(
                frame: CGRectMake(110, 10, self.view.frame.size.width, 60)
            )

            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.center = regionView.center
            label.font = UIFont(name: label.font!.fontName, size: 60.0)
            
            let attributes = [
                NSStrokeColorAttributeName: UIColor.blackColor(),
                NSStrokeWidthAttributeName: -3,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]
            
            var proximityString: String?
            print(beacon.accuracy)
            switch beacon.proximity {
            case .Far:
                regionView.backgroundColor = UIColor.redColor()
                proximityString = "Far"
            case .Near:
                regionView.backgroundColor = UIColor.yellowColor()
                proximityString = "Near"
            case .Immediate:
                regionView.backgroundColor = UIColor.greenColor()
                proximityString = "Immediate"
            case .Unknown:
                proximityString = "Unknown"
            }

            label.attributedText = NSAttributedString(
                string: proximityString!,
                attributes: attributes
            )
            
            regionView.addSubview(label)
            regionView.widthAnchor.constraintEqualToConstant(
                superviewWidth
                ).active = true

            regionView.heightAnchor.constraintEqualToConstant(
                superviewHeight / CGFloat(beacons.count)).active = true

            stackView?.addArrangedSubview(regionView)
            
        }
        
    }

}