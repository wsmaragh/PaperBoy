
import MediaPlayer
import Foundation


protocol CustomAVPlayerItemDelegate {
    func onMetaData(_ metaData:[AVMetadataItem]?)
}


class CustomAVPlayerItem: AVPlayerItem {
    
    var delegate : CustomAVPlayerItemDelegate?
    
    init(url URL:URL) {
        super.init(asset: AVAsset(url: URL) , automaticallyLoadedAssetKeys:[])
        addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    deinit{        
        removeObserver(self, forKeyPath: "timedMetadata")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let avpItem: AVPlayerItem = object as? AVPlayerItem {
            if keyPath == "timedMetadata" {                
                delegate?.onMetaData(avpItem.timedMetadata)
            }
        }
    }
}
