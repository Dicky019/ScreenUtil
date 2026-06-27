//
//  ProfileHeader.swift
//  ScreenUtil Examples
//
//  Banner + avatar + identity. All sizes scale from the design baseline.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct ProfileHeader: View {
    let profile: Profile

    // Avatar diameter expressed as a scaled design size (square).
    private var avatarSize: CGSize { CGSize.scaled(width: 96, height: 96) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12.h) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: Color.bannerColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 140.h)
                    .clipShape(.rect(cornerRadius: 20.r))

                AsyncImage(url: profile.avatar) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.avatarFill
                }
                .frame(width: avatarSize.width, height: avatarSize.height)
                .clipShape(.circle)
                .overlay(Circle().strokeBorder(.avatarStroke, lineWidth: 4.w))
                .offset(x: 20.w, y: avatarSize.height / 2)
            }
            .padding(.bottom, avatarSize.height / 2)

            VStack(alignment: .leading, spacing: 4.h) {
                Text(profile.name)
                    .font(.system(size: 24.sp, weight: .bold))
                Text("@\(profile.username)")
                    .font(.system(size: 15.sp))
                    .foregroundStyle(.secondaryText)
                if let bio = profile.bio {
                    Text(bio)
                        .font(.system(size: 15.sp))
                        .padding(.top, 4.h)
                }
            }
        }
    }
}
