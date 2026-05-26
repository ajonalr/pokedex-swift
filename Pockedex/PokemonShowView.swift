import SwiftUI
import AVFoundation

struct PokemonShowView: View {
    let pokemonUrl: String
    
    @State private var detail: PokemonDetail?
    @State private var isFlipped = false
    @State private var holoRotation: Double = 0
    @State private var player: AVPlayer? // Para el sonido
    
    
    
    
    var body: some View {
        ZStack {
            // Fondo oscuro para que resalte la carta
            Color.black.ignoresSafeArea()
            
            if let detail = detail {
                // LA CARTA
                ZStack {
                    // --- PARTE TRASERA ---
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue.gradient)
                        .overlay(
                            VStack {
                                Text("Datos de \(detail.name.capitalized)")
                                    .font(.title2).bold().foregroundColor(.white)
                                let _ = print(pokemonUrl)
                                Text("ID: #\(detail.id)")
                                    .foregroundColor(.white.opacity(0.8))
                                
                               
                                // Aquí puedes agregar más stats después
                            }
                                .onAppear { print("👀 Viendo el reverso de: \(detail)") }
                        )
                        // Si está de frente, ocultamos la parte trasera girándola
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .opacity(isFlipped ? 1 : 0)
                    
                    // --- PARTE FRONTAL ---
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.yellow.gradient) // Color base de la carta
                        .overlay(
                            VStack {
                                Text(detail.name.capitalized)
                                    .font(.largeTitle).bold().padding(.top)
                                
                                // Imagen del Pokémon
                                AsyncImage(url: URL(string: detail.sprites.frontDefault ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 200, height: 200)
                                Spacer()
                            }
                        )
                        // EFECTO HOLOGRÁFICO
                        .overlay(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.5), .pink.opacity(0.3), .cyan.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .rotationEffect(.degrees(holoRotation))
                            .mask(RoundedRectangle(cornerRadius: 25))
                            .blendMode(.colorDodge)
                        )
                        .opacity(isFlipped ? 0 : 1)
                }
                .frame(width: 300, height: 450)
                // ANIMACIÓN DE GIRO 3D
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .shadow(color: .white.opacity(0.2), radius: 20, x: 0, y: 0)
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isFlipped.toggle()
                    }
                }
                // ANIMACIÓN DEL BRILLO (Holo)
                .onAppear {
                    withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                        holoRotation = 360
                    }
                    playSound(url: detail.cries?.latest)
                }
                
            } else {
                ProgressView("Fabricando carta...")
                    .foregroundColor(.white)
            }
        }
        .task {
            await fetchDetail()
        }
    }
    
    // FUNCIONES AUXILIARES
        func fetchDetail() async {
            guard let url = URL(string: pokemonUrl) else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // --- FORMA PRO (Moderna y automática) ---
                // Creamos una instancia del decodificador
                let decoder = JSONDecoder()
                // Le decimos que traduzca automáticamente de snake_case a camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Decodificamos usando nuestro decoder personalizado
                self.detail = try decoder.decode(PokemonDetail.self, from: data)
                
             
            } catch {
                print("Error cargando detalle: \(error)")
            }
        }
    func playSound(url: String?) {
        guard let urlString = url, let soundUrl = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: soundUrl)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
  
}





