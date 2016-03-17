-- | Renders the search results
module Handler.Search where

import Onionhoo.Summary
import Onionhoo.Summary.Bridge as B
import Onionhoo.Summary.Relay as R
import Onionhoo.Query (summaryQuery)

import Import

import qualified Data.Text as T

-- | perform the Onionoo-query and display results, split by type
getSearchR :: Handler Html
getSearchR = do
  query <- lookupGetParam "q" 
  case query of
    Nothing -> defaultLayout [whamlet|
                                <h2>No query found
                                <p>
                                  Please go back and provide a keyword to
                                  search by
                             |]
    Just q -> do
      (Just summary) <- lift $ performOnionooSearch $ T.unpack q

      defaultLayout $ do
        let bs = bridges summary
            rs = relays summary
            fp = T.pack . R.f -- ^ helper functions to access record
            hfp = T.pack . B.h

        setTitle $ toHtml $ "Search results for " ++ q
        $(widgetFile "searchresult")

-- | helper for fetching a summary document
performOnionooSearch :: String -> IO (Maybe Summary)
performOnionooSearch query = do
  resp <- summaryQuery ["search=" ++ query]
  case resp of
    (Left _) -> return Nothing
    (Right summary) -> return $ Just summary

-- the above function is leading in the right direction, but maybe could be
-- made more general. We'll have to think about this... TODO, anyway
