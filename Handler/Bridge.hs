module Handler.Bridge where

import Onionhoo.Query (detailQuery)
import Onionhoo.Detail
import Onionhoo.Detail.Bridge as B

import Import
import Util

import Data.Maybe as M
import qualified Data.Text as T
import Data.Time

getBridgeR :: Text -> Handler Html
getBridgeR hfp = do
  details <- liftIO $ detailQuery ["fingerprint=" ++ T.unpack hfp] 
  case details of
    (Left err) -> defaultLayout [whamlet|
<h2>An error occurred.
<p>#{err}
|]
    (Right result) -> do
      let (bridge:[]) = bridges result
      defaultLayout $ do
        setTitle $ toHtml $ "Details for " ++ (M.fromMaybe "(unknown)" (nickname bridge))        
        $(widgetFile "bridge")
      where
        uptime :: Bridge -> String
        uptime br = 
          let (Just l) = toUTCTime $ bridgesPublished result
              (Just f) = toUTCTime $ M.fromMaybe (lastSeen br) (lastRestarted br)
              diff = diffUTCTime l f
          in
            prettyDate diff 
        toUTCTime :: String -> Maybe UTCTime
        toUTCTime = parseTimeM True defaultTimeLocale "%F %T"

