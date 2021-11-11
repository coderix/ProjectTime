//
//  SelectSomethingView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 08.08.21.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text("Please select something from the menu (arrow left)")
            .italic()
            .foregroundColor(.secondary)

    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
