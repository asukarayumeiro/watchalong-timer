module I18n exposing (..)


type alias Label =
    { start : String
    , pause : String
    , reset : String
    , backward : String
    , forward : String
    , minusSign : String
    }


labelJa : Label
labelJa =
    { start = "開始"
    , pause = "一時停止"
    , reset = "リセット"
    , backward = "1秒戻す"
    , forward = "1秒進める"
    , minusSign = "マイナス"
    }


labelEn : Label
labelEn =
    { start = "Start"
    , pause = "Pause"
    , reset = "Reset"
    , backward = "Backward 1sec"
    , forward = "Forward 1sec"
    , minusSign = "minus"
    }