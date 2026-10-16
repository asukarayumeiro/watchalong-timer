module Msg exposing (Msg(..), update)

import Model exposing (Model)
import Time
import Process
import Task

type Msg
    = Start
    | Pause
    | Reset
    | UpdateTime Time.Posix
    | RewindSec Int
    | FastForwardSec Int
    | NoOp
    | CountdownStart
    | CountdownTick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model
                | paused = False
                , countdownRemaining = Nothing
              }
            , Cmd.none
            )

        Pause ->
            ( { model
                | paused = True
                , current = Nothing
                , countdownRemaining = Nothing
              }
            , Cmd.none
            )

        Reset ->
            ( { model
                | timeMillis = 0
                , paused = True
                , current = Nothing
                , countdownRemaining = Nothing
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

        CountdownStart ->
            case model.countdownRemaining of
                Nothing ->
                    ( { model | countdownRemaining = Just 10 }
                    , Task.perform (\_ -> CountdownTick) (Process.sleep 1000)
                    )

                Just _ ->
                    ( model, Cmd.none )

        CountdownTick ->
            case model.countdownRemaining of
                Just remaining ->
                    if remaining <= 1 then
                        ( { model
                            | countdownRemaining = Nothing
                            , paused = False
                            , current = Nothing
                          }
                        , Cmd.none
                        )

                    else
                        ( { model | countdownRemaining = Just (remaining - 1) }
                        , Task.perform (\_ -> CountdownTick) (Process.sleep 1000)
                        )

                Nothing ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


calculateMillis : Maybe Time.Posix -> Int -> Time.Posix -> Int
calculateMillis prevTime prevMillis currentTime =
    case prevTime of
        Just prev ->
            prevMillis + (Time.posixToMillis currentTime - Time.posixToMillis prev)

        Nothing ->
            prevMillis