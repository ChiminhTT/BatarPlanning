module DispoTable.Update exposing (update)

import DispoTable.HttpHelper as HttpHelper
import DispoTable.Model as Model exposing (Model, Msg(..))
import Http


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserData (Ok users) ->
            ( { model | users = users }, Cmd.none )

        UserData (Err _) ->
            ( model, Cmd.none )

        UpdateDisponibility user newDispo day ->
            let
                request =
                    HttpHelper.updatePostRequest user newDispo day
                        |> Http.send UpdateUser
            in
            ( model, Cmd.batch [ request ] )

        UpdateUser (Ok updatedUser) ->
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

        UpdateUser (Err _) ->
            ( model, Cmd.none )
