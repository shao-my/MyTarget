//
//  SettingsScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI


struct SettingsScreen: View {
    //@AppStorage("shouldUseDarkMode") private var shouldUseDarkMode: Bool = false
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    //@AppStorage(.preferredWeightUnit) private var unit: MyWeightUnit
    @AppStorage(.startTab) private var startTab: HomeScreen.Tab = .summary
    @State private var confirmationDialog: Dialog = .inactive
    
    private var shouldShowDialog: Binding<Bool> {
        Binding (
            get: { confirmationDialog != .inactive},
            set: { _ in confirmationDialog = .inactive}
        )
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            Section("基本设定") {
                Toggle(isOn: $shouldUseDarkMode){
                    Label("深色模式", systemImage: .moon)
                }
                .toggleStyle(.switch)
                
                /*Picker(selection: $unit) {
                    ForEach(MyWeightUnit.allCases){ $0 }
                } label: {
                    Label("单位", systemImage: .uninSign)
                }
                
                
                
                Picker(selection: $startTab) {
                    Text("随机食物").tag(HomeScreen.Tab.picker)
                    Text("食物清单").tag(HomeScreen.Tab.list)
                } label: {
                    Label("启动画面", systemImage: .house)
                }*/
                
            }
            
            Section("危险区域") {
                ForEach(Dialog.allCases) { dialog in
                    Button(dialog.rawValue) {
                        confirmationDialog = dialog
                    }.tint(Color(.label))
                }
            }
        }
        .confirmationDialog(confirmationDialog.rawValue,
                            isPresented: shouldShowDialog,
                            titleVisibility: .visible) {
            Button("确定", role: .destructive, action: confirmationDialog.action)
            Button("取消", role: .cancel){}
        } message: {
            Text(confirmationDialog.message)
        }
    }
}

private enum Dialog: String{
    case resetSettings = "重置设定"
    case resetFoodList = "重置食物记录"
    case inactive
    
    var message: String {
        switch self {
        case .resetSettings:
            return "将重置颜色、单位等设置，\n此操作无法复原，确定进行吗？"
        case .resetFoodList:
            return "将重置食物清单，\n此操作无法复原，确定进行吗？"
        case .inactive:
            return ""
        }
    }
    
    func action()   {
        switch self {
        case .resetSettings:
            let keys: [UserDefaults.Key] = [.shouldUseDarkMode, .startTab]
            for key in keys {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        case .resetFoodList:
            UserDefaults.standard.removeObject(forKey: UserDefaults.Key.startTab.rawValue )
        case .inactive:
            return
        }
    }
}

extension Dialog: CaseIterable {
    static let allCases: [Dialog] = [.resetSettings, .resetFoodList]
}

extension Dialog: Identifiable {
    var id: Self { self }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
