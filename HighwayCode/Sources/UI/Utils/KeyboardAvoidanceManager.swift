//
//  KeyboardAvoidanceManager.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 01.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class KeyboardAvoidanceManager {

    private let scrollView: UIScrollView
    private let distance: CGFloat

    init(scrollView: UIScrollView, distance: CGFloat) {
        self.scrollView = scrollView
        self.distance = distance
        self.isRunning = false
    }

    /// Indicates whether manager is currently working.
    private(set) var isRunning: Bool

    /// View being tracked.
    private(set) var trackedView: UIView?

    /// Changed tracked view.
    func setTrackedView(_ trackedView: UIView) {
        self.trackedView = trackedView
    }

    /// Starts manager.
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    /// Stops manager.
    func stop() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -

    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let trackedView = self.trackedView,
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        keyboardWillShow(keyboardFrame: keyboardFrame, trackedView: trackedView)
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    private func keyboardWillShow(keyboardFrame: CGRect, trackedView: UIView) {
        let scrollViewFrame = scrollView.convert(scrollView.bounds, to: nil)
        let scrollViewInsetAdjustment = scrollView.adjustedContentInset.bottom - scrollView.contentInset.bottom
        // Height of part of keyboard which overlaps scroll view with insets.
        let adjustedKeyboardHeight = max(
            scrollViewFrame.maxY - keyboardFrame.minY - scrollViewInsetAdjustment, 0
        )
        let trackedViewFrame = trackedView.convert(trackedView.bounds, to: scrollView)
        let adjustedContentHeight = trackedViewFrame.maxY + distance + adjustedKeyboardHeight
        scrollView.contentInset.bottom = max(0, adjustedContentHeight - scrollView.contentSize.height)
        let insetContentViewHeight = scrollView.bounds.height - scrollView.adjustedContentInset.bottom
        let contentOffset = adjustedContentHeight - insetContentViewHeight
        scrollView.contentOffset.y = clamp(
            value: contentOffset,
            lower: -scrollView.adjustedContentInset.top,
            upper: scrollView.contentSize.height - insetContentViewHeight
        )
        scrollView.scrollIndicatorInsets.bottom = max(0, adjustedKeyboardHeight)
    }

}
