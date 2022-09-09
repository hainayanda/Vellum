//
//  GizmoError.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 11/08/22.
//

import Foundation

public enum GizmoError: Error {
    case encodingError(reason: String)
    case jsonTypeError(reason: String)
}
