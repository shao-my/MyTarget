//
//  QuartzSheet.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/14.
//

import SwiftUI

extension SummaryScreen{
    enum Sheet: View, Identifiable {
        case newQuartzHold((QuartzPrms) -> Void)
        case newQuartzQuit((QuartzPrms) -> Void)
        case editQuartz(Binding<QuartzPrms>)
        
        var id: DayBook.ID {
            switch self {
            case .newQuartzHold:
                return UUID()
            case .newQuartzQuit:
                return UUID()
            case .editQuartz(let binding):
                return binding.wrappedValue.id
            }
        }
        var body: some View {
            switch self {
            case .newQuartzHold(let onSubmit):
                QuartzForm(quartzPrms: QuartzPrms.newHold, onSubmit: onSubmit)
            case .newQuartzQuit(let onSubmit):
                QuartzForm(quartzPrms: QuartzPrms.newQuit,onSubmit: onSubmit)
            case .editQuartz(let binding):
                QuartzForm(quartzPrms: binding.wrappedValue) {binding.wrappedValue = $0} 
            }
        }
    }
}
