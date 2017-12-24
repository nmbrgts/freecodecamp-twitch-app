port module LocalStorage exposing (..)


port save : String -> Cmd msg


port delete : String -> Cmd msg


port forceSave : List String -> Cmd msg
