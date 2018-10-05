module Main exposing (Flags, decodeList, decoder, getDisponibilityClass, init, initialCmd, initialModel, main, update, userDecoder, view, viewUser, weekDispoDecoder)

import Browser
import DispoTable.Model
import DispoTable.User exposing (User, WeekDisponibility)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, at, bool, field, int, list, map, string, succeed)
import Json.Encode exposing (Value)


server_api_url =
    "http://localhost:4000/api/"


type alias Flags =
    Int


initialModel : DispoTable.Model.Model
initialModel =
    { users = []
    }


userDecoder : Decoder User
userDecoder =
    Json.Decode.map3 User
        (field "id" int)
        (field "name" string)
        weekDispoDecoder


userEncoder : User -> Bool -> DispoTable.Model.Day -> Value
userEncoder user newDispo day =
    let
        dayKey =
            case day of
                DispoTable.Model.Monday ->
                    "monday"

                DispoTable.Model.Tuesday ->
                    "tuesday"

                DispoTable.Model.Wednesday ->
                    "wednesday"

                DispoTable.Model.Thursday ->
                    "thursday"

                DispoTable.Model.Friday ->
                    "friday"

                DispoTable.Model.Saturday ->
                    "saturday"

                DispoTable.Model.Sunday ->
                    "sunday"

        userJson =
            Json.Encode.object
                [ ( dayKey, Json.Encode.bool newDispo )
                ]
    in
    Json.Encode.object [ ( "user", userJson ) ]


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


initialCmd : Cmd DispoTable.Model.Msg
initialCmd =
    decoder
        |> Http.get "http://localhost:4000/api/users"
        |> Http.send DispoTable.Model.UserData


init : flags -> ( DispoTable.Model.Model, Cmd DispoTable.Model.Msg )
init flags =
    ( initialModel, initialCmd )


viewUser : User -> Html DispoTable.Model.Msg
viewUser user =
    tr [ style "text-align" "center", style "font-size" "1.5em" ]
        [ td [] [ text user.name ]
        , td [ getDisponibilityClass user.weekDispo.monday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.monday) DispoTable.Model.Monday) ] []
        , td [ getDisponibilityClass user.weekDispo.tuesday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.tuesday) DispoTable.Model.Tuesday) ] []
        , td [ getDisponibilityClass user.weekDispo.wednesday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.wednesday) DispoTable.Model.Wednesday) ] []
        , td [ getDisponibilityClass user.weekDispo.thursday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.thursday) DispoTable.Model.Thursday) ] []
        , td [ getDisponibilityClass user.weekDispo.friday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.friday) DispoTable.Model.Friday) ] []
        , td [ getDisponibilityClass user.weekDispo.saturday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.saturday) DispoTable.Model.Saturday) ] []
        , td [ getDisponibilityClass user.weekDispo.sunday, onClick (DispoTable.Model.UpdateDisponibility user (not user.weekDispo.sunday) DispoTable.Model.Sunday) ] []
        ]


getDisponibilityClass : Bool -> Attribute msg
getDisponibilityClass dispo =
    case dispo of
        False ->
            class "table-light"

        True ->
            class "bg-success"


view : DispoTable.Model.Model -> Browser.Document DispoTable.Model.Msg
view model =
    let
        body =
            div [ class "table-responsive" ]
                [ table [ class "table table-bordered table-sm table-striped" ]
                    [ thead [ class "thead-dark" ]
                        [ tr [ style "text-align" "center", style "font-size" "1.5em" ]
                            [ th [ scope "col" ] [ text "Les Batars" ]
                            , th [ scope "col" ] [ text "Lundi" ]
                            , th [ scope "col" ] [ text "Mardi" ]
                            , th [ scope "col" ] [ text "Mercredi" ]
                            , th [ scope "col" ] [ text "Jeudi" ]
                            , th [ scope "col" ] [ text "Vendredi" ]
                            , th [ scope "col" ] [ text "Samedi" ]
                            , th [ scope "col" ] [ text "Dimanche" ]
                            ]
                        ]
                    , tbody []
                        (List.map viewUser (List.sortBy .name model.users))
                    ]
                ]
    in
    { body = [ body ]
    , title = "BatarPlanning - Home"
    }


update : DispoTable.Model.Msg -> DispoTable.Model.Model -> ( DispoTable.Model.Model, Cmd DispoTable.Model.Msg )
update msg model =
    case msg of
        DispoTable.Model.UserData (Ok users) ->
            ( { model | users = users }, Cmd.none )

        DispoTable.Model.UserData (Err _) ->
            ( model, Cmd.none )

        DispoTable.Model.UpdateDisponibility user newDispo day ->
            let
                request =
                    updatePostRequest user newDispo day
                        |> Http.send DispoTable.Model.UpdateUser
            in
            ( model, Cmd.batch [ request ] )

        DispoTable.Model.UpdateUser (Ok updatedUser) ->
            let
                updateUsers user =
                    if user.id == updatedUser.id then
                        { user | weekDispo = updatedUser.weekDispo }

                    else
                        user

                updatedUsers =
                    List.map updateUsers model.users
            in
            ( { model | users = updatedUsers }, Cmd.none )

        DispoTable.Model.UpdateUser (Err _) ->
            ( model, Cmd.none )


updatePostRequest : User -> Bool -> DispoTable.Model.Day -> Http.Request User
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


updateWeek : User -> User
updateWeek user =
    let
        week =
            user.weekDispo

        newWeek =
            { week | monday = True }
    in
    { user | weekDispo = newWeek }


main : Program Flags DispoTable.Model.Model DispoTable.Model.Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
