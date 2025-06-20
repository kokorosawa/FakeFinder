import SwiftUI

struct HistoryView: View {
    // @StateObject private var viewModel = LoadingViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView{
            VStack {
                CardView()
                CardView()
                CardView(result: false)
                CardView()
                CardView()
                CardView()
                CardView(result: false)
            }
        }
    }
}

#Preview {
    HistoryView(path: .constant(NavigationPath()))
}
