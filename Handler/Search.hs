{-# LANGUAGE OverloadedStrings #-}
module Handler.Search where

import Onionhoo.Query (summaryQuery)
import Onionhoo.Summary
import Onionhoo.Summary.Bridge as B
import Onionhoo.Summary.Relay as R


import Import

import qualified Data.Text as T

getSearchR :: Handler Html
getSearchR = do
  query <- lookupGetParam "q"
  case query of
    Nothing -> defaultLayout [whamlet|<h2>Nothing found|]
    Just q -> do
        (Just summary) <- lift $ performOnionooSearch $ T.unpack q
        defaultLayout $ do
          let bs = bridges summary
              rs = relays summary
              fp = T.pack . R.f -- ^ helper functions to access record
              hfp = T.pack . B.h
          setTitle $ toHtml $ "Search results for " ++ q
          $(widgetFile "searchresult")

performOnionooSearch :: String -> IO (Maybe Summary)
performOnionooSearch query = do
  resp <- summaryQuery ["search=" ++ query]
  case resp of
    (Left _) -> return Nothing
    (Right summary) -> return $ Just summary
