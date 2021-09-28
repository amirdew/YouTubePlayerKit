import Foundation

// MARK: - YouTubePlayerWebView+loadPlayer

extension YouTubePlayerWebView {
    
    /// Load the YouTubePlayer to this WKWebView
    /// - Returns: A Bool value if the YouTube player has been successfully loaded
    @discardableResult
    func loadPlayer() -> Bool {
        // Declare YouTubePlayer HTML
        let youTubePlayerHTML: YouTubePlayer.HTML
        do {
            // Try to initialize YouTubePlayer HTML
            youTubePlayerHTML = try .init(
                options: .init(
                    player: self.player,
                    originURL: self.originURL
                )
            )
        } catch {
            // Send error state
            self.playerStateSubject.send(
                .error(
                    .setupFailed(error)
                )
            )
            // Return false as setup has failed
            return false
        }
        #if !os(macOS)
        // Update user interaction enabled state.
        // If no configuration is provided `true` value will be used
        self.isUserInteractionEnabled = self.player.configuration.isUserInteractionEnabled ?? true
        // Update allows Picture-in-Picture media playback
        self.configuration.allowsPictureInPictureMediaPlayback = self.player
            .configuration
            .allowsPictureInPictureMediaPlayback ?? true
        #endif
        // Load HTML string
        self.loadHTMLString(
            youTubePlayerHTML.contents,
            baseURL: self.originURL
        )
        // Return success
        return true
    }
    
}