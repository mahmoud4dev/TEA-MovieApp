//
//  AppIndicator.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 14/08/2025.
//

import UIKit

class AppIndicator {
    
    //MARK: - properties -
    private let indicatorContainer: UIView  = UIView()
    private let indicatorView: UIView = UIView()
    private let indicatorImageView: UIImageView = UIImageView()
    private let length: CGFloat = UIScreen.main.bounds.width * 0.2
    private let innerLength: CGFloat = UIScreen.main.bounds.width * 0.2
    private let duration: TimeInterval = 1.4
    private var timer: Timer?
    private let tag: Int = 19920301
    
    static let shared: AppIndicator = AppIndicator()
    
    //MARK: - Initializer -
    private init() {}
    
    
    //MARK: - Private Methods -
    private func handleInitialView(isGif: Bool) {
        
        self.indicatorContainer.tag = self.tag
        self.indicatorContainer.alpha = 0
        self.indicatorContainer.backgroundColor = .black.withAlphaComponent(0.2)
        self.indicatorView.backgroundColor = .clear
        self.indicatorImageView.contentMode = .scaleAspectFit
        if isGif {
            self.indicatorImageView.image = UIImage.gifImageWithName("indicatorGifImage")
        } else {
            self.indicatorImageView.image = UIImage(named: "indicatorImage")
        }
        self.indicatorView.layer.cornerRadius = 15
        self.indicatorView.clipsToBounds = true
        
        self.indicatorView.addSubview(self.indicatorImageView)
        self.indicatorContainer.addSubview(self.indicatorView)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        window.addSubview(self.indicatorContainer)
        
        //MARK:- Add constraints
        self.indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.indicatorContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        self.indicatorContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        self.indicatorView.heightAnchor.constraint(equalToConstant: self.length).isActive = true
        self.indicatorView.widthAnchor.constraint(equalToConstant: self.length).isActive = true
        self.indicatorView.centerYAnchor.constraint(equalTo: self.indicatorContainer.centerYAnchor).isActive = true
        self.indicatorView.centerXAnchor.constraint(equalTo: self.indicatorContainer.centerXAnchor).isActive = true
        
        self.indicatorImageView.heightAnchor.constraint(equalToConstant: self.innerLength).isActive = true
        self.indicatorImageView.widthAnchor.constraint(equalToConstant: self.innerLength).isActive = true
        self.indicatorImageView.centerYAnchor.constraint(equalTo: self.indicatorView.centerYAnchor).isActive = true
        self.indicatorImageView.centerXAnchor.constraint(equalTo: self.indicatorView.centerXAnchor).isActive = true
    }
    private func startTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.startAnimate), userInfo: nil, repeats: false)
        }
    }
    private func stopTimer() {
        self.timer?.invalidate()
        timer = nil
    }
    @objc private func startAnimate() {
        UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveLinear) {
            self.indicatorImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.indicatorImageView.alpha = 0
            
        } completion: { (_) in
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveLinear) {
                self.indicatorImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                self.indicatorImageView.alpha = 1
            } completion: { (_) in
                if self.timer != nil {
                    self.timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(self.startAnimate), userInfo: nil, repeats: false)
                }
            }
        }

    }
    @objc private func stopAnimate() {
        self.stopTimer()
    }
    
    //MARK: - Action Methods -
    func show(isGif: Bool) {
        self.handleInitialView(isGif: isGif)
        UIView.animate(withDuration: 0.3) {
            self.indicatorContainer.alpha = 1
            if !isGif {
                self.startTimer()
            }
        }
    }
    func dismiss() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.animate(withDuration: 0.2) {
            window.viewWithTag(self.tag)?.alpha = 0
        } completion: { _ in
            self.stopAnimate()
            window.viewWithTag(self.tag)?.removeFromSuperview()
        }
    }
    
}

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }

    var currentWindow: UIWindow? {
        return UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.first(where: { $0.isKeyWindow })
    }
}
