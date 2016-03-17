-- | Displays information on bridges
module Handler.Bridge where

import Onionhoo.Query (detailQuery)
import Onionhoo.Detail
import Onionhoo.Detail.Bridge as B

import Import
import Util

import Data.Maybe as M
import qualified Data.Text as T
import Data.Time (parseTimeM, diffUTCTime)

-- | fetch data from Onionoo and display
getBridgeR :: Text -> Handler Html
getBridgeR hfp = do -- remember that we're usinng a hashed fingerprint here
  details <- liftIO $ detailQuery ["fingerprint=" ++ T.unpack hfp] 
  case details of
    (Left err) -> defaultLayout [whamlet|
                                  <h2>An error occurred.
                                  <p>#{err}
                                |]
                                -- ^ TODO: improve error handling
    (Right result) -> do
      let (bridge:[]) = bridges result
      defaultLayout $ do
        setTitle $ toHtml $ "Details for " ++ (M.fromMaybe "(unknown)" (nickname bridge))        
        $(widgetFile "bridge")
      where
        -- | computes the UTC difference between the point in time the bridge
        -- was last restarted (or: last seen in a consensus) and the timestamp
        -- the current consensus started being valid.
        uptime :: Bridge -> String
        uptime br = 
          let (Just l) = toUTCTime $ bridgesPublished result
              (Just f) = toUTCTime $ M.fromMaybe (lastSeen br) (lastRestarted br)
              diff = diffUTCTime l f
          in
            prettyDate diff -- prettyDate from Util
        -- | since we're not receiving an actual ISO8601 UTC-timestamp, we need
        -- to summon sume parsing voodoo to get the right format
        toUTCTime :: String -> Maybe UTCTime
        toUTCTime = parseTimeM True defaultTimeLocale "%F %T"

