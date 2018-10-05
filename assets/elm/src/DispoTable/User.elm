module DispoTable.User exposing (User, WeekDisponibility, updateWeek)


type alias User =
    { id : Int
    , name : String
    , weekDispo : WeekDisponibility
    }


type alias WeekDisponibility =
    { monday : Bool
    , tuesday : Bool
    , wednesday : Bool
    , thursday : Bool
    , friday : Bool
    , saturday : Bool
    , sunday : Bool
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
