module I18n exposing (..)


type alias Label =
    { start : String
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
    }


labelJa : Label
labelJa =
    { start = "開始"
    , pause = "一時停止"
    , reset = "リセット"
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
    }


labelEn : Label
labelEn =
    { start = "Start"
    , pause = "Pause"
    , reset = "Reset"
    , backward = "Backward 1sec"
    , forward = "Forward 1sec"
    , backward10 = "Backward 10sec"
    , backward60 = "Backward 1min"
    , backward600 = "Backward 10min"
    , backward3600 = "Backward 1hour"
    , forward10 = "Forward 10sec"
    , forward60 = "Forward 1min"
    , forward600 = "Forward 10min"
    , forward3600 = "Forward 1hour"
    }