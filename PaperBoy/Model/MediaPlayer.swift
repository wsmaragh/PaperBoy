
import Foundation
import MediaPlayer


struct MediaPlayer {
    static var radio = AVPlayer()
}

class StationAVPlayerItem: AVPlayerItem {
    
    init(url URL:URL) {
        super.init(asset: AVAsset(url: URL) , automaticallyLoadedAssetKeys:[])
    }

}
