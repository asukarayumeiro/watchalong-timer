module Msg exposing (Msg(..), update)

import Model exposing (Model)
import Time


type Msg
    = Start
    | Pause
    | Reset
    | UpdateTime Time.Posix
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
                | timeMillis = 0
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