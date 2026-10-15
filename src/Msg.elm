port module Msg exposing (Msg(..), update)

import Model exposing (Model, Setting, defaultSetting)
import Time
import Url.Builder as UB


port setQueryString : String -> Cmd msg


type Msg
    = Start
    | Pause
    | Reset
    | UpdateTime Time.Posix
    | UpdateResetTime Int
    | RewindSec Int
    | FastForwardSec Int
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | paused = False }, Cmd.none )

        Pause ->
            ( { model | paused = True, current = Nothing }, Cmd.none )

        Reset ->
            ( { model
                | timeMillis = model.setting.initialTimeSeconds * 1000
                , paused = True
                , current = Nothing
              }
            , Cmd.none
            )

        UpdateTime current ->
            ( { model
                | timeMillis = calculateMillis model.current model.timeMillis current
                , current = Just current
              }
            , Cmd.none
            )

        UpdateResetTime seconds ->
            ( { model | setting = { initialTimeSeconds = seconds } }
            , setQueryString <| urlFromSetting { initialTimeSeconds = seconds }
            )

        RewindSec sec ->
            ( { model | timeMillis = model.timeMillis - sec * 1000 }, Cmd.none )

        FastForwardSec sec ->
            ( { model | timeMillis = model.timeMillis + sec * 1000 }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


calculateMillis : Maybe Time.Posix -> Int -> Time.Posix -> Int
calculateMillis prevTime prevMillis currentTime =
    case prevTime of
        Just prev ->
            prevMillis + (Time.posixToMillis currentTime - Time.posixToMillis prev)

        Nothing ->
            prevMillis


urlFromSetting : Setting -> String
urlFromSetting setting =
    if setting.initialTimeSeconds == defaultSetting.initialTimeSeconds then
        ""

    else
        UB.toQuery
            [ UB.string "init" (String.fromInt setting.initialTimeSeconds) ]