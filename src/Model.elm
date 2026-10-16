module Model exposing (..)

import Time


type alias Model =
    { timeMillis : Int
    , paused : Bool
    , current : Maybe Time.Posix
    , countdownTarget : Maybe Int
    , countdownMode : Bool
    }
