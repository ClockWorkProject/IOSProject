//
//  TimerView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct TimerView: View {
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.second)
                .ignoresSafeArea()
            HStack{
                Text("Projekt")
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(hours):\(minutes):\(seconds)")
                    .font(Font.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    if !timerIsPaused
                    {
                        startTimer()
                    }
                }, label: {
                    if timerIsPaused {
                        Image(systemName: "play")
                    } else {
                        Image(systemName: "pause")
                    }
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "multiply")
                })
                Spacer()
            }
        } .frame(width: .infinity, height: 64, alignment: .top)
        
    }
    func startTimer(){
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours = self.hours + 1
                } else {
                    self.minutes = self.minutes + 1
                }
            } else {
                self.seconds = self.seconds + 1
            }
        }
    }
    
    func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }
}


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
