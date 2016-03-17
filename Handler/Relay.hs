-- | Dispalys information on relays
module Handler.Relay where

import Onionhoo.Query (detailQuery)
import Onionhoo.Detail
import Onionhoo.Detail.Relay as R

import Import
import Util

import Data.Maybe as M
import qualified Data.Text as T
import Data.Time (parseTimeM, diffUTCTime)

-- | fetch relay-data from Onionoo and display in view
getRelayR :: Text -> Handler Html
getRelayR fp = do
  details <- liftIO $ detailQuery ["fingerprint=" ++ T.unpack fp] 
  case details of
    (Left err) -> defaultLayout [whamlet|
                                  <h2>An error occurred.
                                  <p>#{err}
                                |]
                                -- ^ TODO: Improve error handling
    (Right result) -> do
      let (relay:[]) = relays result
      defaultLayout $ do
        setTitle $ toHtml $ "Details for " ++ (M.fromMaybe "(unknown)" (nickname relay))        
        $(widgetFile "relay")
      where
        -- | computes uptime based on timestamp of current consensus and last
        -- restarted time; see Handler.Bridge.
        -- TODO: can this be generalized?
        uptime :: Relay -> String
        uptime rel = 
          let (Just l) = toUTCTime $ relaysPublished result
              (Just f) = toUTCTime $ M.fromMaybe (lastSeen rel) (lastRestarted rel)
              diff = diffUTCTime l f
          in
            prettyDate diff 
        toUTCTime :: String -> Maybe UTCTime
        toUTCTime = parseTimeM True defaultTimeLocale "%F %T"
