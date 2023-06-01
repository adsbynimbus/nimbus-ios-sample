import NimbusKit
import SwiftUI

struct Log: Identifiable, Equatable {
    let id = UUID()
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
}


class Logger: ObservableObject {
    @Published var pending: [Log] = []
    
    convenience init(_ preview: [Log]) {
        self.init()
        pending.append(contentsOf: preview)
    }
    
    func append(_ log: String) {
        pending.append(Log(log))
        objectWillChange.send()
    }
    
    func logRender(_ ad: NimbusAd) {
        append("Rendered: \(ad.testIdentifier)")
    }
    
    func logEvent(_ event: NimbusEvent) {
        var formattedEvent: String
        switch event {
        case .firstQuartile:
            formattedEvent = "FIRST_QUARTILE"
        case .thirdQuartile:
            formattedEvent = "THIRD_QUARTILE"
        default:
            formattedEvent = event.rawValue.uppercased()
        }
        append("Event: \(formattedEvent)")
    }
    
    func logError(_ error: NimbusError) {
        append("Error: \(error.localizedDescription)")
    }
}

struct ScreenLogger: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var logger: Logger
    @State private var logs: [Log] = []
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(logs) {
                    Text($0.text)
                        .font(.proximaNova(size: 18))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                }
            }.onAppear {
                logs = logger.pending
            }.onChange(of: logger.pending) { array in
                logs = logger.pending
            }.frame(maxWidth: .infinity, alignment: .bottomLeading)
        }.frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .bottomLeading)
    }
}

struct ScreenLogger_Previews: PreviewProvider {
    static let previewLogger = Logger([Log("Hello"), Log("Goodbye")])
    static var previews: some View {
        ScreenLogger().environmentObject(previewLogger)
    }
}
