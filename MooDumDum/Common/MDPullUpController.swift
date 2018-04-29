import UIKit

open class MDPullUpController: UIViewController,UIGestureRecognizerDelegate {
    
    private var leftConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    
    open var willMoveToStickyPoint: ((_ point: CGFloat) -> Void)?
    open var didMoveToStickyPoint: ((_ point: CGFloat) -> Void)?
    
    open var pullUpControllerPreviewOffset: CGFloat {
        return 50
    }
    
    open var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    open var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return []
    }

    public final var pullUpControllerAllStickyPoints: [CGFloat] {
        let sc_allStickyPoints = [pullUpControllerPreviewOffset, pullUpControllerPreferredSize.height]
        return sc_allStickyPoints.sorted()
    }
    
    open var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    
    open var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 10, y: 10, width: 300, height: UIScreen.main.bounds.height - 20)
    }
    
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    private var portraitPreviousStickyPointIndex: Int?
    
    open func pullUpControllerMoveToVisiblePoint(_ visiblePoint: CGFloat, completion: (() -> Void)?) {
        guard isPortrait else { return }
        topConstraint?.constant = (parent?.view.frame.height ?? 0) - visiblePoint
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.parent?.view?.layoutIfNeeded()
            },
            completion: { _ in
                completion?()
        }
        )
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isPortrait = size.height > size.width
        var targetStickyPoint: CGFloat?
        
        if !isPortrait {
            portraitPreviousStickyPointIndex = currentStickyPointIndex
        } else if
            let portraitPreviousStickyPointIndex = portraitPreviousStickyPointIndex,
            portraitPreviousStickyPointIndex < pullUpControllerAllStickyPoints.count
        {
            targetStickyPoint = pullUpControllerAllStickyPoints[portraitPreviousStickyPointIndex]
            self.portraitPreviousStickyPointIndex = nil
        }
        
        coordinator.animate(alongsideTransition: { [weak self] coordinator in
            self?.refreshConstraints(size: size)
            if let targetStickyPoint = targetStickyPoint {
                self?.pullUpControllerMoveToVisiblePoint(targetStickyPoint, completion: nil)
            }
        })
    }
    
    func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGestureRecognizer?.minimumNumberOfTouches = 1
        panGestureRecognizer?.maximumNumberOfTouches = 1
        if let panGestureRecognizer = panGestureRecognizer {
            view.addGestureRecognizer(panGestureRecognizer)
        }
        
        
    }
    
    //댓글에서 필요한 제스쳐
    func setupTapGestureRecognizer(){
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingTapGesture(_:)))
        tapGestureRecognizer?.numberOfTapsRequired = 1;
        tapGestureRecognizer?.delegate = self;
        
        if let tapGestureRecognizer = tapGestureRecognizer {
            view.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    fileprivate func setupConstrains() {
        guard let parentView = parent?.view else { return }
        
        topConstraint = view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0)
        leftConstraint = view.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 0)
        widthConstraint = view.widthAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.width)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.height)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint, heightConstraint].flatMap { $0 })
    }
    
    private var currentStickyPointIndex: Int {
        let stickyPointTreshold = (self.parent?.view.frame.height ?? 0) - (topConstraint?.constant ?? 0)
        let stickyPointsLessCurrentPosition = pullUpControllerAllStickyPoints.map { abs($0 - stickyPointTreshold) }
        guard let minStickyPointDifference = stickyPointsLessCurrentPosition.min() else { return 0 }
        return stickyPointsLessCurrentPosition.index(of: minStickyPointDifference) ?? 0
    }
    
    private func nearestStickyPointY(yVelocity: CGFloat) -> CGFloat {
        var currentStickyPointIndex = self.currentStickyPointIndex
        if abs(yVelocity) > 700 { // 1000 points/sec = "fast" scroll
            if yVelocity > 0 {
                currentStickyPointIndex = max(currentStickyPointIndex - 1, 0)
            } else {
                currentStickyPointIndex = min(currentStickyPointIndex + 1, pullUpControllerAllStickyPoints.count - 1)
            }
        }
        
        willMoveToStickyPoint?(pullUpControllerAllStickyPoints[currentStickyPointIndex])
        return (parent?.view.frame.height ?? 0) - pullUpControllerAllStickyPoints[currentStickyPointIndex]
    }
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            isPortrait,
            let topConstraint = topConstraint,
            let parentViewHeight = parent?.view.frame.height
            else { return }
        
        let yTranslation = gestureRecognizer.translation(in: view).y
        gestureRecognizer.setTranslation(.zero, in: view)
        
        topConstraint.constant += yTranslation
        
        if !pullUpControllerIsBouncingEnabled {
            topConstraint.constant = max(topConstraint.constant, parentViewHeight - pullUpControllerPreferredSize.height)
            topConstraint.constant = min(topConstraint.constant, parentViewHeight - pullUpControllerPreviewOffset)
        }
        
        if gestureRecognizer.state == .ended {
            topConstraint.constant = nearestStickyPointY(yVelocity: gestureRecognizer.velocity(in: view).y)
            animateLayout()
        }
    }
    
    @objc func handleSingTapGesture(_ gestureRecognizer: UIPanGestureRecognizer){
        guard
            isPortrait,
            let topConstraint = topConstraint,
            let parentViewHeight = parent?.view.frame.height
            else { return }
        
        UIView.animate(withDuration: 2, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
            topConstraint.constant = 0
            self.view.removeGestureRecognizer(self.tapGestureRecognizer!)
        }) {result in
            
        }
        
    }
    
    @objc fileprivate func handleInternalScrollViewPanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            isPortrait,
            let scrollView = gestureRecognizer.view as? UIScrollView,
            let lastStickyPoint = pullUpControllerAllStickyPoints.last,
            let parentViewHeight = parent?.view.frame.height,
            let topConstraintValue = topConstraint?.constant
            else { return }
        
        let isScrollingDown = gestureRecognizer.translation(in: view).y > 0
        let shouldScrollingDownTriggerGestureRecognizer = isScrollingDown && scrollView.contentOffset.y <= 0
        let shouldScrollingUpTriggerGestureRecognizer = !isScrollingDown && topConstraintValue != parentViewHeight - lastStickyPoint
        
        if shouldScrollingDownTriggerGestureRecognizer || shouldScrollingUpTriggerGestureRecognizer {
            handlePanGestureRecognizer(gestureRecognizer)
        }
        
        if gestureRecognizer.state.rawValue == 3 { // for some reason gestureRecognizer.state == .ended doesn't work
            topConstraint?.constant = nearestStickyPointY(yVelocity: 0)
            animateLayout()
        }
    }
    
    
    private func animateLayout() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.parent?.view.layoutIfNeeded()
                
                let point = (self?.parent?.view.frame.height ?? 0.0) - (self?.topConstraint?.constant ?? 0.0)
                
                if self?.view.frame.height == point {
                    self?.didMoveToStickyPoint?(point)
                    if let panGestureRecognizer = self?.panGestureRecognizer {
                        self?.view.removeGestureRecognizer(panGestureRecognizer)
                    }
                }
            }
        )
    }
    
    
    private func setPortraitConstraints(parentViewSize: CGSize) {
        topConstraint?.constant = parentViewSize.height - pullUpControllerPreviewOffset
        leftConstraint?.constant = (parentViewSize.width - min(pullUpControllerPreferredSize.width, parentViewSize.width))/2
        widthConstraint?.constant = pullUpControllerPreferredSize.width
        heightConstraint?.constant = pullUpControllerPreferredSize.height
    }
    
    
    private func setLandscapeConstraints() {
        topConstraint?.constant = pullUpControllerPreferredLandscapeFrame.origin.y
        leftConstraint?.constant = pullUpControllerPreferredLandscapeFrame.origin.x
        widthConstraint?.constant = pullUpControllerPreferredLandscapeFrame.width
        heightConstraint?.constant = pullUpControllerPreferredLandscapeFrame.height
    }
    
    fileprivate func refreshConstraints(size: CGSize) {
        if size.width > size.height {
            setLandscapeConstraints()
        } else {
            setPortraitConstraints(parentViewSize: size)
        }
    }
    
    
}

extension UIViewController {
    
    open func addPullUpController(_ pullUpController: MDPullUpController) {
        addChildViewController(pullUpController)
        
        pullUpController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pullUpController.view)
        
        pullUpController.setupPanGestureRecognizer()
        pullUpController.setupConstrains()
        pullUpController.refreshConstraints(size: view.frame.size)
    }    
}

