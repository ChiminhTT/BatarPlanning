module DispoTable.User exposing (User, WeekDisponibility)


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
