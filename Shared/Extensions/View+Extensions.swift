// View+Extensions.swift
import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, title: String = "Error") -> some View {
        alert(item: error) { error in
            Alert(title: Text(title), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        }
    }
}
