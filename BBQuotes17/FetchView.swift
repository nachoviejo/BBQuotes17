//
//  QuoteView.swift
//  BBQuotes17
//
//  Created by Kinamic Kinamic on 19/10/2024.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String

    @State var showCharacterInfo = false

    var body: some View {
        // es para acceder a las dimensiones de la pantalla del celular
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer ()
                        
                        switch vm.status {
                        case .notStated:
                            EmptyView()
                            
                        case .fetching:
                            ProgressView()
                            
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            //                    asyncImage: componente especial de swift que permite fetchear una imagen de una url
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images.randomElement()) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    HStack {
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                            
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisode(for: show)
                            }

                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
