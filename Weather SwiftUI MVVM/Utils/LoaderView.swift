//
//  LoaderView.swift
//  MVVM Product API
//
//  Created by Masrafi Anam on 7/8/24.
//
import SwiftUI

struct LoaderView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(2.0, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
    }
}
