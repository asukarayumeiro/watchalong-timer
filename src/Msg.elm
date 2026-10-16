
module Msg exposing (Msg(..), update)

import Model exposing (Model)
import Task
import Time


type Msg
    = Start
    | Pause
    | Reset
    | UpdateTime Time.Posix
    | RewindSec Int
    | FastForwardSec Int
    | NoOp
    | CountdownStart
    | CountdownStarted Time.Posix
    | ToggleCountdownMode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | paused = False }
            , Cmd.none
            )

        Pause ->
            ( { model
                | timeMillis =
                    Maybe.withDefault model.timeMillis model.countdownTarget
                , paused = True
                , current = Nothing
                , countdownTarget = Nothing
              }
            , Cmd.none
            )

        Reset ->
            ( { model
                | timeMillis = 0
                , paused = True
                , current = Nothing
                , countdownTarget = Nothing
              }
            , Cmd.none
            )

        UpdateTime current ->
            let
                newTime =
                    calculateMillis model.current model.timeMillis current
            in
            case model.countdownTarget of
                Just target ->
                    if newTime >= target then
                        ( { model
                            | timeMillis = target
                            , current = Just current
                            , countdownTarget = Nothing
                          }
                        , Cmd.none
                        )

                    else
                        ( { model
                            | timeMillis = newTime
                            , current = Just current
                          }
                        , Cmd.none
                        )

                Nothing ->
                    ( { model
                        | timeMillis = newTime
                        , current = Just current
                      }
                    , Cmd.none
                    )

        RewindSec sec ->
            ( { model | timeMillis = model.timeMillis - sec * 1000 }
            , Cmd.none
            )

        FastForwardSec sec ->
            ( { model | timeMillis = model.timeMillis + sec * 1000 }
            , Cmd.none
            )

        CountdownStart ->
            case model.countdownTarget of
                Just _ ->
                    ( model, Cmd.none )

                Nothing ->
                    ( model
                    , Task.perform CountdownStarted Time.now
                    )

        CountdownStarted startedAt ->
            ( { model
                | timeMillis = model.timeMillis - 10000
                , countdownTarget = Just model.timeMillis
                , current = Just startedAt
                , paused = False
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )
            
        ToggleCountdownMode ->
            ( { model | countdownMode = not model.countdownMode }
            , Cmd.none
            )


calculateMillis : Maybe Time.Posix -> Int -> Time.Posix -> Int
calculateMillis prevTime prevMillis currentTime =
    case prevTime of
        Just prev ->
            prevMillis
                + (Time.posixToMillis currentTime
                    - Time.posixToMillis prev
                  )

        Nothing ->
            prevMillis
