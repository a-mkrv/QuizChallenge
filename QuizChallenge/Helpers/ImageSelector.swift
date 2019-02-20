//
//  ImageSelector.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 19/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import Photos

public class ImageSelector: NSObject {
    
    static let shared = ImageSelector()
    private var pickCompletion: ((UIImage?) -> Void)?
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    // MARK: - Public method with image picker
    
    func presentImagePicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        
        pickCompletion = completion
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.present(from: viewController, camera: true)
            }))
        
        alertController.addAction(
            UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
                self?.present(from: viewController, camera: false)
            }))
        
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                self?.dismiss()
            }))
        
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    fileprivate func dismiss() {
        pickCompletion = nil
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func present(from viewController: UIViewController, camera: Bool) {
        
        imagePicker.sourceType = camera ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        
        if camera {
            cameraAccess { (status) in
                if status {
                    viewController.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        } else {
            galleryAccess { (status) in
                if status {
                    viewController.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Camera / Photo Gallery Access
    
    fileprivate func cameraAccess(with completion: @escaping (Bool) -> Void) {
        
        switch (AVCaptureDevice.authorizationStatus(for: AVMediaType.video)) {
            
        case .authorized:
            completion(true)
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Camera Denied",
                                          message: "Open Settings for provide access to the camera",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
                completion(false)
            })
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                granted ? completion(true) : completion(false)
                return
            }
        }
    }
    
    fileprivate func galleryAccess(with completion: @escaping (Bool) -> Void) {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .authorized:
            completion(true)
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Gallery Denied",
                                          message: "Open Settings for provide access to the gallery",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
                completion(false)
            })
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (granted) in
                guard granted == .authorized else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
}

// MARK: - UIImagePickerController Delegate

extension ImageSelector: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        pickCompletion?(image)
        dismiss()
    }
}
