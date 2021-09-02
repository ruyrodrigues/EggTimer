import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let hardness = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    var timer = Timer()
    var timePassed = 0
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        
        if let player = player {
            player.stop()
        }
        
        guard let hardnessName = sender.currentTitle else { return }
        
        guard let totalTime = hardness[hardnessName] else { return }
        
        timePassed = 0
        titleLabel.text = hardnessName
        progressView.progress = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            if self.timePassed < totalTime {
                self.timePassed += 1
                self.progressView.progress = Float(self.timePassed) / Float(totalTime)
            } else {
                Timer.invalidate()
                self.titleLabel.text = "DONE!"
                self.playSound()
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
