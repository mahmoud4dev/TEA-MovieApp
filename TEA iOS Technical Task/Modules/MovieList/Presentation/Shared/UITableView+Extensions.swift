//
//  UITableView+Extensions.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}
extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
extension NSObject: ClassNameProtocol {}

private struct AssociatedKeys {
    static var tapHandler = UnsafeRawPointer(bitPattern: 0)
    static var swipeHandler = UnsafeRawPointer(bitPattern: 0)
}

extension UIView {
    func addTapGesture(handler: @escaping () -> Void) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
        // Store the closure in an associated object
        objc_setAssociatedObject(self, &AssociatedKeys.tapHandler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if let tapHandler = objc_getAssociatedObject(self, &AssociatedKeys.tapHandler) as? () -> Void {
            tapHandler()
        }
    }
}
