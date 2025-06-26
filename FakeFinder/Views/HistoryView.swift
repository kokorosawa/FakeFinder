import SwiftUI

struct HistoryView: View {
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(viewModel.logs, id: \.self) { log in
                    CardView(time: log.creatAt!, wavId: log.wavId ?? "NULL", score: Int(log.score), result: log.result)
                }
            }
        }
    }
}
