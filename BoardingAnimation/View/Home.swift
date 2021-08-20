//
//  Home.swift
//  Home
//
//  Created by Michele Manniello on 20/08/21.
//

import SwiftUI

struct Home: View {
    
//    Title and subtitles...
    @State var titles = [
        "Clean your mind from",
        "Unique experience",
        "the ultimate program"
    ]
    @State var subTitles = [
        "Negativity - Stress - Anexity",
        "Prepare your mind for sweet dreams",
        "healty mind - bettere sleep - well being"
    ]
//    Animations...
//    to get initial change
    @State var currentIndex : Int = 2
    @State var titleText : [TextAnimation] = []
    @State var subTitleAnimation : Bool = false
    @State var endAnimation = false
    var body: some View {
        ZStack{
//            Geometry reader for screen size..
            GeometryReader{ proxy in
                let size = proxy.size
//                since for opacty animation...
                Color.black
//                changing image
//                make sure to have only same images as title..
                ForEach(1...3,id:\.self) { index in
                    Image("Pic\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .opacity(currentIndex == (index - 1) ? 1 : 0)
                }
                
                
//                Linear Gradine...
                LinearGradient(colors: [
                    .clear,
                    .black.opacity(0.5),
                    .black
                ], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
//            Bottom Content..
            VStack(spacing: 20){
                HStack(spacing: 0){
                    ForEach(titleText){ text in
                        Text(text.text)
                            .offset(y: text.offset)
                    }
                    .font(.largeTitle.bold())
                }
                .offset(y: endAnimation ? -100 : 0)
                .opacity(endAnimation ? 0 : 1)
                   
                Text(subTitles[currentIndex])
                    .opacity(0.7)
                    .offset(y: !subTitleAnimation ? 80 : 0)
                    .offset(y: endAnimation ? -100 : 0)
                    .opacity(endAnimation ? 0 : 1)
//                Sing in buttons...
                SignInButton(image: "applelogo", text: "Continue with Apple", isSystem: true) {
                    
                }
                .padding(.top)
                SignInButton(image: "google", text: "Continue with Google", isSystem: false) {
                    
                }
                SignInButton(image: "facebook", text: "Continue with Facebook", isSystem: false) {
                    
                }
                
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear(perform: {
            currentIndex = 0
        })
        .onChange(of: currentIndex) { newValue in
//            updating and resetting if last index comes...
            getSpilitedText(text: titles[currentIndex]){
                withAnimation(.easeInOut(duration: 1)){
                    endAnimation.toggle()
                }
//                Updating Index..
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
//                    removing title text...
                    titleText.removeAll()
                    subTitleAnimation.toggle()
                    endAnimation.toggle()
//                    updating index..
                    withAnimation(.easeIn(duration: 0.6)){
                        if currentIndex < (titles.count - 1){
                        currentIndex += 1
                    }else{
//                        setting back to 0...
//                        so it will endless loop...
                        currentIndex = 0
                    }
                    }
                }
            }
        }
    }
//    Spliting Text into array of charactes and animating it....
//    Completion hadler to infrom the animation completion...
    func getSpilitedText(text: String, completion: @escaping ()->()){
        for (index,character) in text.enumerated(){
            titleText.append(TextAnimation(text: String(character)))
//            with time delay setting text offset to 0...
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.03) {
                withAnimation(.easeInOut(duration: 0.5)){
                    titleText[index].offset = 0
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * 0.02) {
            withAnimation(.easeInOut(duration: 0.5)){
                subTitleAnimation.toggle()
            }
//            completion..
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                completion()
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
struct SignInButton: View {
    var image : String
    var text : String
    var isSystem : Bool
    var onClick: ()->()
    var body: some View{
        HStack{
            ( isSystem ? Image(systemName: image) : Image(image)
            
            )
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .foregroundColor(!isSystem ? .white : .black)
        .padding(.vertical,15)
        .padding(.horizontal,40)
        .background(
            .white.opacity(isSystem ? 1 : 0.1),in: Capsule()
        )
        .onTapGesture {
            onClick()
        }
    }
}
