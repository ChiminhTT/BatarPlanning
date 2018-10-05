module Main exposing (Flags, init, main)

import Browser
import DispoTable.HttpHelper as HttpHelper
import DispoTable.Model exposing (initialModel)
import DispoTable.Update
import DispoTable.User exposing (User, WeekDisponibility)
import DispoTable.View


type alias Flags =
    Int


init : flags -> ( DispoTable.Model.Model, Cmd DispoTable.Model.Msg )
init flags =
    ( initialModel, HttpHelper.getUsers )


main : Program Flags DispoTable.Model.Model DispoTable.Model.Msg
main =
    Browser.document
        { init = init
        , view = DispoTable.View.view
        , update = DispoTable.Update.update
        , subscriptions = \_ -> Sub.none
        }
