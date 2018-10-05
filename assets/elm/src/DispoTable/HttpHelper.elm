module DispoTable.HttpHelper exposing (decodeList, decoder, getUsers, server_api_url, updatePostRequest, userDecoder, userEncoder, weekDispoDecoder)

import DispoTable.Model as Model exposing (Day, Msg, dayToStr)
import DispoTable.User exposing (User, WeekDisponibility)
import Http
import Json.Decode exposing (Decoder, at, bool, field, int, list, map, string, succeed)
import Json.Encode exposing (Value)


server_api_url =
    "http://localhost:4000/api/"



-- Requests


getUsers : Cmd Msg
getUsers =
    decoder
        |> Http.get (server_api_url ++ "users")
        |> Http.send Model.UserData


updatePostRequest : User -> Bool -> Day -> Http.Request User
updatePostRequest user newDispo day =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = server_api_url ++ "users/" ++ String.fromInt user.id
        , body = Http.jsonBody (userEncoder user newDispo day)
        , expect = Http.expectJson (at [ "data" ] userDecoder)
        , timeout = Nothing
        , withCredentials = False
        }



-- Decoders


userDecoder : Decoder User
userDecoder =
    Json.Decode.map3 User
        (field "id" int)
        (field "name" string)
        weekDispoDecoder


weekDispoDecoder : Decoder WeekDisponibility
weekDispoDecoder =
    Json.Decode.map7 WeekDisponibility
        (field "monday" bool)
        (field "tuesday" bool)
        (field "wednesday" bool)
        (field "thursday" bool)
        (field "friday" bool)
        (field "saturday" bool)
        (field "sunday" bool)


decodeList : Decoder (List User)
decodeList =
    list userDecoder


decoder : Decoder (List User)
decoder =
    at [ "data" ] decodeList



-- Encoders


userEncoder : User -> Bool -> Day -> Value
userEncoder user newDispo day =
    let
        userJson =
            Json.Encode.object
                [ ( dayToStr day, Json.Encode.bool newDispo )
                ]
    in
    Json.Encode.object [ ( "user", userJson ) ]
