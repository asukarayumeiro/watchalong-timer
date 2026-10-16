module Flag exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)

initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { timeMillis = 0
      , paused = True
      , current = Nothing
      , countdownTarget = Nothing
      , countdownMode = False
      }
    , Cmd.none
    )