//
//  TimerView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var stopwatch = Stopwatch()
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.second)
                .ignoresSafeArea()
            HStack{
                VStack {
                Text("Issue")
                        .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(Color.white)
                Text("Projekt")
                        .font(Font.system(size: 16, weight: .regular))
                        .foregroundColor(Color.white)
                }.padding(8)
                Spacer()
                Text(stopwatch.message)
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    if !stopwatch.isRunning
                    {
                        stopwatch.start()
                    }
                    else {
                        
                    }
                }, label: {
                    if !stopwatch.isRunning {
                        Image(systemName: "play")
                    } else {
                        Image(systemName: "pause")
                    }
                })
                    .padding()
                    .foregroundColor(.white)
                Button(action: {
                    stopwatch.stop()
                }, label: {
                    Image(systemName: "multiply")
                })
                    .padding()
                    .foregroundColor(.white)
            }
        } .frame(width: .infinity, height: 64, alignment: .top)
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}