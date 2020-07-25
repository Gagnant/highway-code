//
//  AnyFinesListElementViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct AnyFinesListElementViewModel: IFinesListElementViewModel {

    private let box: AnyFinesListElementViewModelBase

    init<ViewModel: IFinesListElementViewModel>(_ viewModel: ViewModel) {
        box = AnyFinesListElementViewModelBox(viewModel)
    }

    func accept<V>(visitor: V) -> V.Result where V : IFinesListElementViewModelVisitor {
        return box.accept(visitor: visitor)
    }

    var differenceIdentifier: AnyHashable {
        return box.differenceIdentifier
    }

    func isContentEqual(to source: AnyFinesListElementViewModel) -> Bool {
        return box.isContentEqual(to: source.box)
    }

}

private class AnyFinesListElementViewModelBase: IFinesListElementViewModel {

    func accept<V>(visitor: V) -> V.Result where V : IFinesListElementViewModelVisitor {
        fatalError("Must override")
    }

    var differenceIdentifier: AnyHashable {
        fatalError("Must override")
    }

    func isContentEqual(to source: AnyFinesListElementViewModelBase) -> Bool {
        fatalError("Must override")
    }

}

private final class AnyFinesListElementViewModelBox<ViewModel: IFinesListElementViewModel>: AnyFinesListElementViewModelBase {

    private let viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    override func accept<V>(visitor: V) -> V.Result where V : IFinesListElementViewModelVisitor {
        return viewModel.accept(visitor: visitor)
    }

    override var differenceIdentifier: AnyHashable {
        return AnyHashable(viewModel.differenceIdentifier)
    }

    override func isContentEqual(to source: AnyFinesListElementViewModelBase) -> Bool {
        if let sourceBox = source as? AnyFinesListElementViewModelBox<ViewModel> {
            return viewModel.isContentEqual(to: sourceBox.viewModel)
        }
        return false
    }

}
