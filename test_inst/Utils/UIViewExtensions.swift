//
//  Extensions.swift
//  imdbTop250
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell: ReusableView {}
extension UITableViewCell: ReusableView {}


protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
    static func viewFromNib(owner: UIView?) -> UIView
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    static func viewFromNib(owner: UIView? = nil) -> UIView {
        let bundle = Bundle(for: self)
        let view = bundle.loadNibNamed(nibName, owner: owner, options: nil)?.first as! UIView

        return view
    }
    
    func loadFromNib() {
        let view = type(of: self).viewFromNib(owner: self)
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        layoutAttachViewToSuperview(view: view)
    }
    
    func layoutAttachViewToSuperview(view: UIView) {
        let views = ["view" : view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: views)
        addConstraints(horizontalConstraints + verticalConstraints)
    }
}

extension UIView: NibLoadableView {}


extension UITableView {
    
    func registerClass<T>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerNib<T>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
