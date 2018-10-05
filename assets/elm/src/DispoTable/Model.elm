module DispoTable.Model exposing (Day(..), Model, Msg(..))

import DispoTable.User exposing (User)
import Http


type alias Model =
    { users : List User
    }


type Msg
    = UserData (Result Http.Error (List User))
    | UpdateDisponibility User Bool Day
    | UpdateUser (Result Http.Error User)


type Day
    = Monday
    | Tuesday
    | Wednesday
    | Thursday
    | Friday
    | Saturday
    | Sunday
