module Flag exposing (..)

import Model exposing (Model, defaultSetting)
import Msg exposing (Msg)


type alias SettingFromQuery =
    { init : Maybe Int
    }


initialModel : SettingFromQuery -> ( Model, Cmd Msg )
initialModel setting =
    let
        initialTimeSeconds =
            setting.init
                |> Maybe.withDefault defaultSetting.initialTimeSeconds
    in
    ( { timeMillis = initialTimeSeconds * 1000
      , paused = True
      , current = Nothing
      , setting = { initialTimeSeconds = initialTimeSeconds }
      }
    , Cmd.none
    )