import Foundation

struct AudioAnalyzer {
    static func calculateRMS(samples: [Float]) -> Float {
        guard !samples.isEmpty else { return 0 }
        let sum = samples.reduce(Float.zero) { $0 + $1 * $1 }
        return sqrt(sum / Float(samples.count))
    }

    static func hasMeaningfulAudio(rms: Float, threshold: Float = 0.01) -> Bool {
        rms >= threshold
    }
}
