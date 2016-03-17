-- | Homepage with instructions and Top 10
module Handler.Home where

import Onionhoo.Detail
import Onionhoo.Detail.Relay as R
import Onionhoo.Query (detailQuery)

import Import
import Util

import Data.Maybe as M
import Data.Text as T


-- | gets the Top 10 relays by consensus weight and renders the view
getHomeR :: Handler Html
getHomeR = do
  -- This pattern (lifting, destructuring, matching) is very common, maybe it
  -- should be generalized or put into onionhoo? TODO
  details <- liftIO $ detailQuery ["limit=10", "order=-consensus_weight"]
  case details of
    (Left err) -> defaultLayout [whamlet|
                                  <h2>An error occurred.
                                  <p>#{err}
                                |]
    (Right result) -> do
      defaultLayout $ do
        setTitle "Welcome To Halium!"
        $(widgetFile "homepage")
