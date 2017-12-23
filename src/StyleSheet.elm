module StyleSheet exposing (Class(..), Variation(..), stylesheet)

import Style
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Color exposing (..)


twitchDarkPurple : Color
twitchDarkPurple =
    rgb 74 54 124


twitchLightPurple : Color
twitchLightPurple =
    rgb 100 64 164


twitchVLightPurple : Color
twitchVLightPurple =
    rgb 125 91 190


twitchOffWhite : Color
twitchOffWhite =
    rgb 250 249 250


twitchWhite : Color
twitchWhite =
    rgb 255 255 255


twitchBorderGrey : Color
twitchBorderGrey =
    rgb 218 216 222


type Class
    = None
    | Root
    | Background
    | WhiteBG
    | WhiteTile
    | DPurpleBG
    | LPurpleBG
    | LLPurpleBG
    | TopBarButton
    | OnlineIcon
    | WhiteText
    | TitleText


type Variation
    = Selected


stylesheet : Style.StyleSheet Class Variation
stylesheet =
    Style.styleSheet
        [ Style.style None []
        , Style.style Root
            [ Font.typeface [ Font.sansSerif ] ]
        , Style.style DPurpleBG
            [ Color.background twitchDarkPurple
            , Color.text twitchWhite
            ]
        , Style.style LPurpleBG
            [ Color.background twitchLightPurple ]
        , Style.style LLPurpleBG
            [ Color.background twitchVLightPurple ]
        , Style.style WhiteBG
            [ Color.background twitchOffWhite ]
        , Style.style WhiteTile
            [ Color.background twitchWhite
            , Color.text black
            , Color.border twitchBorderGrey
            , Border.bottom 1
            ]
        , Style.style TopBarButton
            [ Color.background twitchLightPurple
            , Color.text twitchWhite
            , Style.variation Selected
                [ Color.background twitchVLightPurple ]
            ]
        , Style.style OnlineIcon
            [ Border.bottom 10
            , Color.border twitchDarkPurple
            ]
        , Style.style WhiteText
            [ Color.text twitchWhite ]
        , Style.style Background
            [ Color.background darkGrey ]
        , Style.style TitleText
            [ Font.size 35 ]
        ]
