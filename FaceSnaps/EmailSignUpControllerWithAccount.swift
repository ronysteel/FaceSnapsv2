//
//  EmailSignUpControllerWithAccount.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/27/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class EmailSignUpControllerWithAccount: UIViewController {
    
    var email: String!
    
    lazy var addPhotoButton: UIButton = {
        let image = UIImage(named: "add_photo")!
        let imageHighlighted = UIImage(named: "add_photo_highlighted")!
        let button = UIButton()
        
        button.setImage(image, for: .normal)
        button.setImage(imageHighlighted, for: .highlighted)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addPhotoButtonContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        
        view.addArrangedSubview(self.addPhotoButton)
        
        return view
    }()
    
    lazy var fullNameTextField: LoginTextField = {
        let text = "Full Name"
        let textField = LoginTextField(text: text)
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.backgroundColor = .extraLightGray
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        
        textField.delegate = self
        textField.returnKeyType = .next
        
        return textField
    }()
    
    lazy var passwordTextField: LoginTextField = {
        let text = "Password"
        let textField = LoginTextField(text: text)
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.backgroundColor = .extraLightGray
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        
        textField.delegate = self
        textField.returnKeyType = .go
        textField.isSecureTextEntry = true
        
        return textField

    }()
    
    lazy var nextButton: NextButton = {
        return NextButton(frame: .zero)
    }()
    
    lazy var accountSignUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        
        stackView.addArrangedSubview(self.addPhotoButtonContainer)
        stackView.addArrangedSubview(self.fullNameTextField)
        stackView.addArrangedSubview(self.passwordTextField)
        stackView.addArrangedSubview(self.nextButton)
        
        return stackView
    }()

    // Already have an account? Sign In.
    lazy var signInView: LoginBottomView = {
        let view = LoginBottomView(labelType: .signIn, topBorderColor: .lightGray)
        
        view.interactableLabel.setTextColors(nonBoldColor: .lightGray, boldColor: .buttonBlue)
        return view
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
//        manager.delegate = self
        
        return manager
    }()
    
    lazy var alertController: UIAlertController = {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let attributedTitle = NSAttributedString(string: "Change Profile Photo", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
        ])
        
        controller.setValue(attributedTitle, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            // .. cancel
        })
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            let vc = FaceSnapsImagePickerController()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            // Present media picker manager with camera
//            self.mediaPickerManager.presentImagePickerController(animated: true, withSourceType: .camera)
        })
        
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            // Present photo library
            self.mediaPickerManager.presentImagePickerController(animated: true, withSourceType: .photoLibrary)
        })
        
        controller.addAction(takePhoto)
        controller.addAction(chooseFromLibrary)
        controller.addAction(cancelAction)
        
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable/disable next button
        fullNameTextField.addTarget(self, action: #selector(EmailSignUpControllerWithAccount.textFieldEmptyCheck(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(EmailSignUpControllerWithAccount.textFieldEmptyCheck(sender:)), for: .editingChanged)
        
        // Configure tap recognizer
        configureTapRecognizer()
        
        // Add target to nextbutton
        nextButton.addTarget(self, action: #selector(EmailSignUpControllerWithAccount.nextButtonTapped(sender:)), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(EmailSignUpControllerWithAccount.addPhotoTapped(sender:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.addSubview(accountSignUpStackView)
        view.addSubview(signInView)

        accountSignUpStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                addPhotoButton.heightAnchor.constraint(equalToConstant: 84),
                addPhotoButton.widthAnchor.constraint(equalToConstant: 84),
                accountSignUpStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
                accountSignUpStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
                accountSignUpStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
                nextButton.heightAnchor.constraint(equalTo: fullNameTextField.heightAnchor),
                signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
                signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
                signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // TODO: Add profile photo
    func addPhotoTapped(sender: UIButton) {
        present(alertController, animated: true, completion: nil)
        //        mediaPickerManager.presentImagePickerController(animated: true)
    }
    
    // MARK: Sign In tapped
    func configureTapRecognizer() {
        signInView.interactableLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpController.handleTapOnLabel(tapGesture:))))
    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let label = signInView.interactableLabel
        if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
            // Go back
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: Submit account photo, full name, & password to sign up
    func nextButtonTapped(sender: UIButton) {
        guard let fullName = fullNameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        // TODO: Proto User struct?
        let vc = UsernameSignUpController()
        vc.fullName = fullName
        vc.password = password
        vc.email = email
        vc.profileImage = addPhotoButton.imageView?.image
        vc.view.backgroundColor = .white
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: UITextFieldDelegate
extension EmailSignUpControllerWithAccount: UITextFieldDelegate {
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            view.endEditing(true)
            nextButton.sendActions(for: .touchUpInside)
        }
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if fullNameTextField.isBlank() || passwordTextField.isBlank() {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}


// MARK: FaceSnapsImagePickerControllerDelegate
extension EmailSignUpControllerWithAccount: FaceSnapsImagePickerControllerDelegate {
    func imagePickerController(_ picker: FaceSnapsImagePickerController, didFinishPickingImage image: UIImage) {
        addPhotoButton.setImage(image, for: .normal)
        addPhotoButton.setImage(image, for: .highlighted)
    }
//    func imagePickerController(_ picker: FaceSnapsImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        addPhotoButton.setImage(image, for: .normal)
//        addPhotoButton.setImage(image, for: .highlighted)
//    }
}
