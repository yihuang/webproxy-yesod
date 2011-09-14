{-# LANGUAGE TemplateHaskell, QuasiQuotes, OverloadedStrings #-}
module Handler.Root where

import Foundation hiding (Request)
import Network.HTTP.Enumerator (parseUrl, withManager, http, Request)
import Network.HTTP.Types (Status, ResponseHeaders)
import Network.Wai (Response (ResponseEnumerator))
import Data.ByteString (ByteString)
import Blaze.ByteString.Builder (Builder, fromByteString)
import Data.Enumerator (Iteratee, run_, ($$), joinI)
import qualified Data.Enumerator.List as EL
import Data.Text (unpack)

blaze :: (Status -> ResponseHeaders -> Iteratee Builder IO a)
      -> Status -> ResponseHeaders -> Iteratee ByteString IO a
blaze f status headers =
  let notEncoding ("Content-Encoding", _) = False
      notEncoding _ = True
      headers' = filter notEncoding headers
      iter = f status headers'
  in  joinI $ EL.map fromByteString $$ iter

fetch :: Request IO
       -> (Status -> ResponseHeaders -> Iteratee Builder IO a)
       -> IO a
fetch req f = withManager $ \m ->
                run_ $ http req (blaze f) m

getRootR :: Handler RepHtml
getRootR = do
    murl <- lookupGetParam "url"
    case murl of
        Nothing -> defaultLayout [whamlet|
<form method=get>
    <input type=text name=url />
    <input type=submit value="提交" />
        |]
        Just url -> do
            req <- liftIO $ parseUrl (unpack url)
            sendWaiResponse $ ResponseEnumerator $ fetch req
