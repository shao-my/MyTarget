//
//  SelfRecount.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/9.
//

import SwiftUI

struct SelfRecount: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("完成").font(.body.bold())
                    }
                    .push(to: .trailing)
                    .padding()
                    
                    Text("书写").font(.largeTitle)
                
  
                }
            }
            .padding()
            .background(.bg2)
        }
    }
}

struct SelfRecount_Previews: PreviewProvider {
    static var previews: some View {
        SelfRecount()
    }
}
