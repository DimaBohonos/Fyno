//
//  ViewController.swift
//  Fyno
//
//  Created by dima on 08.06.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let mapHeight = 390.0
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countCountriesLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FynoManager.shared.showBucketAll = false
        FynoManager.shared.showBeenToAll = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        FynoManager.shared.delegate = self
        
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange.init(maxCenterCoordinateDistance: 10000000000000), animated: true)
        
        mainView.clipsToBounds = false
        mainView.layer.cornerRadius = 16
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        scrollView.clipsToBounds = false
        scrollView.layer.masksToBounds = false
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.focusOnPointAndShowGlobe()
//        }
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    }
    
    func reloadMap() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        let list = FynoManager.shared.getCountriesForMap()
        
        list.forEach { item in
            mapView.addAnnotation(item)
        }
        
    }

    func focusOnPointAndShowGlobe() {
        let mapHeight = mapView.bounds.height // the constraint of visible Map area will base on HEIGHT of mapview
        
        // These are standard/base value from adjustment
        let standardMapHeight: CGFloat = 450
        let standardCameraDistance: CGFloat = 24 * 1000 * 1000 // 24,000 km
        
        let targetDistance = (mapHeight / standardMapHeight) * standardCameraDistance
        let center = CLLocationCoordinate2D(latitude: 20, longitude: -70)
        let camera = MKMapCamera(lookingAtCenter: center, fromDistance: targetDistance, pitch: 0, heading: 0)
        self.mapView.setCamera(camera, animated: true)
        
    }

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
//        let countryInfo = FynoManager.shared.bucketList[indexPath.row]
        
        if let coordinates = view.annotation?.coordinate {
//            let region = MKCoordinateRegion(center: coordinates, span: mapView.region.span)
//            mapView.setRegion(region, animated: true)
            
            let viewRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000000, longitudinalMeters: 2000000)
            
            mapView.setRegion(viewRegion, animated: false)
            
        }
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if FynoManager.shared.showMoreBeenTo {
                return FynoManager.shared.beenToListShort.count + 1
            }
            return FynoManager.shared.beenToListShort.count
        }else if section == 1 {
            if FynoManager.shared.showMoreBucket {
                return FynoManager.shared.bucketListShort.count + 1
            }
            return FynoManager.shared.bucketListShort.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 65
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = HeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 65))
        
        if section == 0 {
            view.title = "I’ve been to"
        }else if section == 1 {
            view.title = "My bucket list"
        }
        
        view.actionHandler = { view in
            
            let controller: CountryListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "select_country") as! CountryListViewController
            
            if section == 0 {
                controller.selectedCountries = FynoManager.shared.beenToList
            }else if section == 1 {
                controller.selectedCountries = FynoManager.shared.bucketList
            }
            
            controller.saveActionHandler = { res in
                if section == 0 {
                    FynoManager.shared.beenToList = res
                }else if section == 1 {
                    FynoManager.shared.bucketList = res
                }
            }
            
            self.present(controller, animated: true)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if FynoManager.shared.showMoreBeenTo && indexPath.row == FynoManager.shared.beenToLimit {
                
                let cellMore: MoreCountriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_more", for: indexPath) as! MoreCountriesTableViewCell
                //moreBeenToCount
                cellMore.titleLabel?.text = "See \(FynoManager.shared.moreBeenToCount) more"
                return cellMore
                
            }
        }else if indexPath.section == 1 {
            if FynoManager.shared.showMoreBucket && indexPath.row == FynoManager.shared.bucketLimit {
                
                let cellMore: MoreCountriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_more", for: indexPath) as! MoreCountriesTableViewCell
                //moreBeenToCount
                cellMore.titleLabel?.text = "See \(FynoManager.shared.moreBucketCount) more"
                return cellMore
                
            }
        }
        
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        
        if indexPath.section == 0 {
            cell.countryInfo = FynoManager.shared.beenToList[indexPath.row]
        }else if indexPath.section == 1 {
            cell.countryInfo = FynoManager.shared.bucketList[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if FynoManager.shared.showMoreBeenTo && indexPath.row == FynoManager.shared.beenToLimit {
                FynoManager.shared.showBeenToAll = true
            }else{
                
                let countryInfo = FynoManager.shared.beenToList[indexPath.row]
                if let coordinates = countryInfo.coordinates {
//                    let region = MKCoordinateRegion(center: coordinates, span: mapView.region.span)
//                    mapView.setRegion(region, animated: true)
                    let viewRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000000, longitudinalMeters: 2000000)
                       
                    mapView.setRegion(viewRegion, animated: false)
                    
                }
                
            }
        }else if indexPath.section == 1 {
            if FynoManager.shared.showMoreBucket && indexPath.row == FynoManager.shared.bucketLimit {
                FynoManager.shared.showBucketAll = true
            }else{
                
                let countryInfo = FynoManager.shared.bucketList[indexPath.row]
                
                if let coordinates = countryInfo.coordinates {
//                    let region = MKCoordinateRegion(center: coordinates, span: mapView.region.span)
//                    mapView.setRegion(region, animated: true)
                    
                    let viewRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000000, longitudinalMeters: 2000000)
                       
                    mapView.setRegion(viewRegion, animated: false)
                    
                }
                
            }
            
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            
            if scrollView.contentOffset.y < 0 {
                scrollView.contentOffset.y = 0
            }
            
        }
//        if scrollView == self.scrollView {
//            
//            if scrollView.contentOffset.y < 0 {
//                scrollView.contentOffset.y = 0
//            }
//            if scrollView.contentOffset.y > 180 {
//                scrollView.contentOffset.y = 180
//            }
//            
//            let height = self.mapHeight - scrollView.contentOffset.y
//            
//            self.mapViewHeightConstraint.constant = max(height, 180)
//            
//        }
        
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == self.tableView {
            if scrollView.contentOffset.y < 5 {
                self.mapViewHeightConstraint.constant = 390
                UIView.animate(withDuration: 0.5) {
//                    self.scrollView.frame.origin.y = 390
                    self.mapViewHeightConstraint.constant = self.mapHeight
                    self.view.layoutIfNeeded()
                } completion: { res in
                    
                }

            }
            if scrollView.contentOffset.y > 5 {
                UIView.animate(withDuration: 0.5) {
//                    self.scrollView.frame.origin.y = 180
                    self.mapViewHeightConstraint.constant = 180
                    self.view.layoutIfNeeded()
                } completion: { res in
                    
                }
                
            }
        }
        
    }
}

extension ViewController: FynoManagerDelegate {
    func reloadCountriesInfo(_ manager: FynoManager) {
        
        self.tableView.reloadData()
        self.reloadMap()
        
        self.countCountriesLabel.text = "\(FynoManager.shared.bucketList.count)"
        self.percentLabel.text = "\(Int(FynoManager.shared.percentBucketPercent))%"
        
    }
}
