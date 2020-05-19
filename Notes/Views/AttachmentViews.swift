//
//  AttachmentViews.swift
//  Notes
//
//  Created by Azat Almeev on 05.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

private extension Date {

    var day: String {
        String(Calendar.current.dateComponents(.init(arrayLiteral: .day), from: self).day!)
    }

    var month: String {
        Calendar.current.shortMonthSymbols[
            Calendar.current.dateComponents(.init(arrayLiteral: .month), from: self).month! - 1]
    }

    var year: String {
        String(Calendar.current.dateComponents(.init(arrayLiteral: .year), from: self).year!)
    }

    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

//struct DateAttachmentView: View {
//
//    let date: Date
//
//    var body: some View {
//        VStack {
//            Text(self.date.day).font(.system(size: 20, weight: .bold))
//            Text(self.date.month).font(.system(size: 20))
//        }
//    }
//}

struct FullDateAttachmentView: View {

    let date: Date

    var body: some View {
        Text(self.date.day).font(.system(size: 20, weight: .bold)) +
            Text(" " + self.date.month + " ").font(.system(size: 17)) +
            Text(self.date.year).font(.system(size: 20))
    }
}

struct DateTimeAttachmentView: View {

    let date: Date

    var body: some View {
        VStack {
            Text(self.date.date).font(.system(size: 15))
            Text(self.date.time).font(.system(size: 20, weight: .bold))
        }
    }
}

struct TimeAttachmentView: View {

    let date: Date

    var body: some View {
        Text(self.date.time).font(.system(size: 20, weight: .bold))
    }
}

struct ImageAttachmentView: View {

    let image: UIImage

    var body: some View {
        HStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
            Spacer()
            Text("business.attachments.type.image.title")
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 4)
            Spacer()
        }
    }
}

//struct VideoAttachmentView: View {
//
//    var body: some View {
//        ZStack {
//            Image("image")
//                .resizable()
//                .scaledToFill()
//                .blur(radius: 4)
//                .frame(width: 100, height: 100)
//                .clipped()
//            Image(systemName: "play.circle")
//                .resizable()
//                .frame(width: 50, height: 50)
//        }
//    }
//}

struct LinkAttachmentView: View {

    let url: URL

    var body: some View {
        LinkView(url: self.url)
    }
}

struct GeolocationAttachmentView: View {

    let location: String
    let title: String
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(self.location).font(.system(size: 12, weight: .semibold))
                    Spacer()
                }
                if !self.title.isEmpty {
                    HStack {
                        Text(self.title).font(.system(size: 12))
                        Spacer()
                    }
                }
            }
            Spacer()
            Image(systemName: "mappin.circle")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .padding(8)
    }
}
