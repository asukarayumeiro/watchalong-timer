module I18n exposing (..)


type alias Label =
    { start : String
    , countdownStart : String
    , pause : String
    , reset : String
    , backward : String
    , forward : String
    , backward10 : String
    , backward60 : String
    , backward600 : String
    , backward3600 : String
    , forward10 : String
    , forward60 : String
    , forward600 : String
    , forward3600 : String
    , countdownMode : String
    }


labelJa : Label
labelJa =
    { start = "すぐスタート"
    , countdownStart = "10秒カウントしてスタート"
    , pause = "ポーズ"
    , reset = "クリア"
    , backward = "-1秒"
    , forward = "+1秒"
    , backward10 = "-10秒"
    , backward60 = "-1分"
    , backward600 = "-10分"
    , backward3600 = "-1時間"
    , forward10 = "+10秒"
    , forward60 = "+1分"
    , forward600 = "+10分"
    , forward3600 = "+1時間"
    , countdownMode = "カウントダウンモード"
    }
