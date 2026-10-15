module View exposing (DisplayTime, millisToDisplayTime, view)

import Html exposing (Html, button, div, i, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import I18n
import Model exposing (Model)
import Msg exposing (Msg(..))


type alias DisplayTime =
    { isMinus : Bool
    , hours : Int
    , minutes : Int
    , seconds : Int
    }


millisToDisplayTime : Int -> DisplayTime
millisToDisplayTime t =
    let
        absSeconds =
            toFloat t / 1000 |> floor |> abs
    in
    { isMinus = t < 0
    , hours = absSeconds // 3600
    , minutes = absSeconds // 60 |> modBy 60
    , seconds = absSeconds |> modBy 60
    }


view : I18n.Label -> Model -> Html Msg
view label model =
    div [ class "container" ]
        [ viewTimer label model
        ]


viewTimer : I18n.Label -> Model -> Html Msg
viewTimer label model =
    div [ class "grid" ]
        [ div [ class "timer-controls" ]
            [ viewTimerDigits model.timeMillis
            , div []
                [ button
                    [ class "outline"
                    , id "countdown-start-button"
                    ]
                    [ text label.countdownStart  ]
                , startPauseButton label model.paused
                ]
            ]
        , viewTimerControls label model
        ]


viewTimerDigits : Int -> Html Msg
viewTimerDigits millis =
    let
        displayTime =
            millisToDisplayTime millis

        displaySegments =
            [ displayTime.hours, displayTime.minutes, displayTime.seconds ]
    in
    div
        [ class "timer"
        , style "font-family" "'BIZ UDGothic', sans-serif"
        , style "background-color" "#000000"
        , style "color" "#ffffff"
        ]
        [ div [ class "digits" ] <|
            List.concat
                [ [ span (styleTimerSign displayTime.isMinus) [ text "-" ] ]
                , List.foldr joinWithSegment [] <| List.map renderBig2Digits displaySegments
                ]
        ]


joinWithSegment : List (Html Msg) -> List (Html Msg) -> List (Html Msg)
joinWithSegment a b =
    case b of
        [] ->
            a

        _ ->
            List.concat [ a, [ span styleTimerSep [ text ":" ] ], b ]


padZero : Int -> Int -> String
padZero wt digits =
    String.fromInt digits |> String.padLeft wt '0'


styleTimerSep : List (Html.Attribute Msg)
styleTimerSep =
    [ class "sep" ]


styleTimerDigit : List (Html.Attribute Msg)
styleTimerDigit =
    [ class "digit" ]


styleTimerSign : Bool -> List (Html.Attribute Msg)
styleTimerSign isMinus =
    let
        visibility =
            style "visibility" <|
                if isMinus then
                    "visible"

                else
                    "hidden"
    in
    visibility :: styleTimerDigit


renderBig2Digits : Int -> List (Html Msg)
renderBig2Digits digits =
    padZero 2 digits
        |> String.split ""
        |> List.map (\d -> span styleTimerDigit [ text d ])


viewTimerControls : I18n.Label -> Model -> Html Msg
viewTimerControls label model =
    div [ class "controls" ]
        [ div [ class "ff-buttons" ]
            [ div [ class "ff-column" ]
                [ rewindButton 1 label.backward
                , rewindButton 10 label.backward10
                , rewindButton 60 label.backward60
                , rewindButton 600 label.backward600
                , rewindButton 3600 label.backward3600
                ]
            , div [ class "ff-column" ]
                [ fastForwardButton 1 label.forward
                , fastForwardButton 10 label.forward10
                , fastForwardButton 60 label.forward60
                , fastForwardButton 600 label.forward600
                , fastForwardButton 3600 label.forward3600
                ]
            ]
        , div [] [ resetForm label ]
        ]


startPauseButton : I18n.Label -> Bool -> Html Msg
startPauseButton label paused =
    if paused then
        button
            [ id "start-button", class "start-stop-button", onClick Start ]
            [ i [ class "fas", class "fa-play", class "button-icon" ] []
            , text label.start
            ]

    else
        button
            [ id "pause-button", class "start-stop-button", class "secondary", onClick Pause ]
            [ i [ class "fas", class "fa-pause", class "button-icon" ] []
            , text label.pause
            ]


rewindButton : Int -> String -> Html Msg
rewindButton sec caption =
    button [ class "outline", onClick <| RewindSec sec ]
        [ text caption
        ]


fastForwardButton : Int -> String -> Html Msg
fastForwardButton sec caption =
    button [ class "outline", onClick <| FastForwardSec sec ]
        [ text caption
        ]


resetForm : I18n.Label -> Html Msg
resetForm i18n =
    div [ class "reset-form" ]
        [ button [ id "reset-button", class "contrast", class "reset-form-button", onClick Reset ]
            [ i [ class "fas", class "fa-backward-fast", class "button-icon" ] []
            , text i18n.reset
            ]
        ]
