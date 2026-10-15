module View exposing (DisplayTime, ResetTimeValue, millisToDisplayTime, resetTimeValueParser, resetTimeValueToString, view)

import Html exposing (Html, button, div, i, input, label, span, text)
import Html.Attributes exposing (checked, class, for, id, size, step, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput)
import I18n
import Model exposing (Model)
import Msg exposing (Msg(..))
import Parser exposing ((|.), (|=))


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
        [ viewTimerDigits model.timeMillis
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
        , class "d-din-bold"
        , class "greenback"
        , style "color" "#415462"
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
        [ div [] [ startPauseButton label model.paused ]
        , div [ class "ff-buttons" ]
            [ rewindButton label
            , fastForwardButton label
            ]
        , div [] [ resetForm label model.setting.initialTimeSeconds ]
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


rewindButton : I18n.Label -> Html Msg
rewindButton label =
    button [ id "rewind-button", class "outline", onClick <| RewindSec 1 ]
        [ i [ class "fas", class "fa-backward", class "button-icon" ] []
        , text label.backward
        ]


fastForwardButton : I18n.Label -> Html Msg
fastForwardButton label =
    button [ id "fastforward-button", class "outline", onClick <| FastForwardSec 1 ]
        [ text label.forward
        , i [ class "fas", class "fa-forward", class "button-icon" ] []
        ]


type alias ResetTime =
    { isMinus : Bool
    , timeValue : ResetTimeValue
    }


type alias ResetTimeValue =
    { hours : Int
    , minutes : Int
    , seconds : Int
    }


zeroPadIntParser : Parser.Parser Int
zeroPadIntParser =
    Parser.oneOf
        [ Parser.succeed identity |. Parser.chompIf ((==) '0') |= Parser.int
        , Parser.int
        ]


resetTimeValueParser : Parser.Parser ResetTimeValue
resetTimeValueParser =
    Parser.succeed ResetTimeValue
        |= zeroPadIntParser
        |. Parser.symbol ":"
        |= zeroPadIntParser
        |. Parser.symbol ":"
        |= zeroPadIntParser


resetTimeValueToString : ResetTimeValue -> String
resetTimeValueToString value =
    (String.padLeft 2 '0' <| String.fromInt value.hours)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt value.minutes)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt value.seconds)


initialTimeToResetTime : Int -> ResetTime
initialTimeToResetTime initialTimeSeconds =
    let
        absSeconds =
            abs initialTimeSeconds

        hours =
            absSeconds // 3600

        minutes =
            absSeconds // 60 |> modBy 60

        seconds =
            absSeconds |> modBy 60
    in
    { isMinus = initialTimeSeconds < 0
    , timeValue =
        { hours = hours
        , minutes = minutes
        , seconds = seconds
        }
    }


negateIf : Bool -> Int -> Int
negateIf isMinus value =
    if isMinus then
        negate value

    else
        value


updateResetTimeMinus : Int -> Bool -> Msg
updateResetTimeMinus initialTimeSeconds isMinus =
    abs initialTimeSeconds
        |> negateIf isMinus
        |> UpdateResetTime


updateResetTimeValue : Bool -> String -> Msg
updateResetTimeValue isMinus timeValue =
    Parser.run resetTimeValueParser timeValue
        |> Result.toMaybe
        |> Maybe.map (\t -> t.hours * 3600 + t.minutes * 60 + t.seconds)
        |> Maybe.map (negateIf isMinus)
        |> Maybe.map UpdateResetTime
        |> Maybe.withDefault NoOp


resetForm : I18n.Label -> Int -> Html Msg
resetForm i18n initialTimeSeconds =
    let
        resetTime =
            initialTimeToResetTime initialTimeSeconds
    in
    div [ class "reset-form" ]
        [ label [ for "reset-is-minus", class "reset-form-minus" ]
            [ input
                [ id "reset-is-minus"
                , type_ "checkbox"
                , checked resetTime.isMinus
                , onCheck <| updateResetTimeMinus initialTimeSeconds
                ]
                []
            , text i18n.minusSign
            ]
        , input
            [ type_ "time"
            , value <| resetTimeValueToString resetTime.timeValue
            , step "1"
            , size 8
            , class "reset-form-time"
            , onInput <| updateResetTimeValue resetTime.isMinus
            ]
            []
        , button [ id "reset-button", class "contrast", class "reset-form-button", onClick Reset ]
            [ i [ class "fas", class "fa-backward-fast", class "button-icon" ] []
            , text i18n.reset
            ]
        ]