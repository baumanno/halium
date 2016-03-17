module Handler.Relay where

import Onionhoo.Query (detailQuery)
import Onionhoo.Detail
import Onionhoo.Detail.Relay as R

import Import
import Util

import Data.Maybe as M
import qualified Data.Text as T
import Data.Time

getRelayR :: Text -> Handler Html
getRelayR fp = do
  details <- liftIO $ detailQuery ["fingerprint=" ++ T.unpack fp] 
  case details of
    (Left err) -> defaultLayout [whamlet|
<h2>An error occurred.
<p>#{err}
|]
    (Right result) -> do
      let (relay:[]) = relays result
      defaultLayout $ do
        setTitle $ toHtml $ "Details for " ++ (M.fromMaybe "(unknown)" (nickname relay))        
        $(widgetFile "relay")
      where
        uptime :: Relay -> String
        uptime rel = 
          let (Just l) = toUTCTime $ relaysPublished result
              (Just f) = toUTCTime $ M.fromMaybe (lastSeen rel) (lastRestarted rel)
              diff = diffUTCTime l f
          in
            prettyDate diff 
        toUTCTime :: String -> Maybe UTCTime
        toUTCTime = parseTimeM True defaultTimeLocale "%F %T"
