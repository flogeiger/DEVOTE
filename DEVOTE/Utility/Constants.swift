//
//  Constants.swift
//  DEVOTE
//
//  Created by Florian Geiger on 18.03.25.
//
import SwiftUI

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
