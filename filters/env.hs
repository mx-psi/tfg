#!/usr/bin/env runhaskell
import Text.Pandoc.JSON
import qualified Data.Map as Map

main :: IO ()
main = toJSONFilter envtify

raw = (: []) . RawBlock (Format "tex")
comm  name val  = raw $ "\\" ++ name ++ "{" ++ val ++"}"
begin name opts = raw $ "\\begin{" ++ name ++"}[" ++ (maybe "" id opts) ++ "]"
end             = comm "end"
label ident  = if Prelude.null ident then [] else comm "label" ident


envtify :: Block -> [Block]
envtify (Div (ident, [name], values) contents) =
  begin name opts ++ label ident ++ contents ++ end name
  where opts  = Map.lookup "name" (Map.fromList values)
envtify b = [b]
