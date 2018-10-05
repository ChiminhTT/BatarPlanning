module DispoTable.Model exposing (Day(..), Model, Msg(..), dayToStr, initialModel)

import DispoTable.User exposing (User)
import Http


type alias Model =
    { users : List User
    }


type Msg
    = UserData (Result Http.Error (List User))
    | UpdateDisponibility User Bool Day
    | UpdateUser (Result Http.Error User)


initialModel : Model
initialModel =
    { users = []
    }


type Day
    = Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday
    | Sunday


dayToStr : Day -> String
dayToStr day =
    case day of
        Monday ->
            "monday"

        Tuesday ->
            "tuesday"

        Wednesday ->
            "wednesday"

        Thursday ->
            "thursday"

        Friday ->
            "friday"

        Saturday ->
            "saturday"

        Sunday ->
            "sunday"
