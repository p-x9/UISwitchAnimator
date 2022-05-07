//
//  ViewController.swift
//  UISwitchAnimator
//
//  Created by p-x9 on 2022/05/07.
//  
//

import UIKit

class ViewController: UIViewController {
    
    // Please change below properties
    let fps: Int = 10
    let (width, height) = (48, 36)
    
    private(set) var data: [[Int]]!
    private(set) var currentFrameIndex = 0
    private(set) var isAnimating = false

    private let stackView: UIStackView = .switchVerticalStackView
    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        recognizer.numberOfTapsRequired = 2
        return recognizer
    }()
    private var switches = [UISwitch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewConstraints()
        setupGestureRecognizers()
        
        print(#function)
    }

    private func setupViews() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthScale = (view.frame.width / CGFloat(width)) / UISwitch.defaultSize.width
        let heightScale = (view.frame.height / CGFloat(height)) / UISwitch.defaultSize.height
        let scale = min(widthScale, heightScale)
        
        for _ in 0..<height {
            let rowStack: UIStackView = .switchHorizontalStackView
            for _ in 0..<width {
                let uiSwitch: UISwitch = .smallSwitch(scale: scale)
                switches.append(uiSwitch)
                rowStack.addArrangedSubview(uiSwitch)
            }
            stackView.addArrangedSubview(rowStack)
        }
    }
    
    private func setupViewConstraints() {
        var constraints = [NSLayoutConstraint]()
        if width > height {
            constraints += [
                stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
                stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CGFloat(height)/CGFloat(width), constant: 0)
            ]
        } else {
            constraints += [
                stackView.heightAnchor.constraint(equalTo: view.heightAnchor),
                stackView.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: CGFloat(width)/CGFloat(height), constant: 0)
            ]
        }
        
        constraints += [
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupGestureRecognizers() {
        view.addGestureRecognizer(gestureRecognizer)
    }

    func loadData() {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!)
            self.data = try JSONSerialization.jsonObject(with: data) as? [[Int]]
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func startAnimation() {
        guard self.data != nil else { return }
        isAnimating = true
        currentFrameIndex = 0
        Timer.scheduledTimer(timeInterval: 1 / Double(fps),
                             target: self,
                             selector: #selector(updateFrame(_:)),
                             userInfo: nil, repeats: true)
    }
    
    @objc
    func updateFrame(_ timer: Timer) {
        DispatchQueue.global(qos: .userInteractive).async {
            let frameData = self.data[self.currentFrameIndex]
            DispatchQueue.main.async {
                self.switches.enumerated().forEach { i, uiSwitch in
                    uiSwitch.isOn = frameData[i] == 1
                }
            }
            self.currentFrameIndex += 1
            if self.currentFrameIndex >= self.data.count {
                timer.invalidate()
                self.isAnimating = false
            }
        }
    }
    
    @objc
    func handleTapGestureRecognizer() {
        guard !isAnimating else { return }
        
        self.loadData()
        self.startAnimation()
    }
}

private extension UISwitch {
    static let defaultSize = CGSize(width: 51, height: 31)
    
    static func smallSwitch(scale: CGFloat) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.transform = .init(scaleX: scale, y: scale)
        return uiSwitch
    }
}

private extension UIStackView {
    static var switchVerticalStackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }
    
    static var switchHorizontalStackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }
}
