module DispoTable.View exposing (getDisponibilityClass, view, viewUser)

import Browser
import DispoTable.Model exposing (Day(..), Model, Msg(..))
import DispoTable.User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


viewUser : User -> Html Msg
viewUser user =
    tr [ style "text-align" "center", style "font-size" "1.5em" ]
        [ td [] [ text user.name ]
        , td
            [ getDisponibilityClass user.weekDispo.monday
            , onClick (UpdateDisponibility user (not user.weekDispo.monday) Monday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.tuesday
            , onClick (UpdateDisponibility user (not user.weekDispo.tuesday) Tuesday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.wednesday
            , onClick (UpdateDisponibility user (not user.weekDispo.wednesday) Wednesday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.thursday
            , onClick (UpdateDisponibility user (not user.weekDispo.thursday) Thursday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.friday
            , onClick (UpdateDisponibility user (not user.weekDispo.friday) Friday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.saturday
            , onClick (UpdateDisponibility user (not user.weekDispo.saturday) Saturday)
            ]
            []
        , td
            [ getDisponibilityClass user.weekDispo.sunday
            , onClick (UpdateDisponibility user (not user.weekDispo.sunday) Sunday)
            ]
            []
        ]


getDisponibilityClass : Bool -> Attribute msg
getDisponibilityClass dispo =
    case dispo of
        False ->
            class "table-light"

        True ->
            class "bg-success"


view : Model -> Browser.Document Msg
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
