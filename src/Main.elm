module Main exposing (..)

import Html exposing (Html, programWithFlags, i)
import Http
import Json.Decode as Decode exposing (Decoder)
import LocalStorage
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import Element.Keyed as Keyed
import StyleSheet exposing (Class(..), Variation(..), stylesheet)
import Task


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { mode : Mode
    , streamer : List Streamer
    , inputText : String
    }


type Mode
    = ViewAll
    | ViewOnline
    | ViewOffline
    | Edit


type alias StreamerInfo a =
    { name : a
    , logoUrl : a
    , streamUrl : a
    , game : a
    , status : a
    }


type Streamer
    = Init String
    | Online (StreamerInfo String)
    | Offline String String
    | Failure String


type alias StreamerInfo_ =
    { name : String
    , logoUrl : String
    , streamUrl : String
    , game : String
    , statue : String
    }


type alias Flags =
    { names : List String }


init : Flags -> ( Model, Cmd Msg )
init { names } =
    let
        streamers =
            List.map Init names
    in
        Model ViewAll streamers ""
            ! requestStreamersFromList streamers


requestStreamersFromList : List Streamer -> List (Cmd Msg)
requestStreamersFromList streamers =
    List.map getName streamers
        |> List.map2
            requestStreamerInfo
            (List.range 0 <| List.length streamers)



-- UPDATE


type Msg
    = Nope
    | RequestStreamer String
    | HandleResponse Int (Result Http.Error (StreamerInfo (Maybe String)))
    | UpdateMode Mode
    | DeleteStreamer String
    | UpdateInputText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nope ->
            model ! []

        RequestStreamer name ->
            { model
                | streamer = Init name :: model.streamer
            }
                ! [ requestStreamerInfo 0 name
                  , LocalStorage.save <| String.toLower name
                  ]

        HandleResponse idx (Ok s) ->
            { model
                | streamer =
                    updateStreamer idx resolveStreamer s model.streamer
            }
                ! []

        -- Responses should no long error
        HandleResponse _ _ ->
            model ! []

        UpdateMode newMode ->
            { model | mode = newMode } ! []

        DeleteStreamer name ->
            { model
                | streamer =
                    List.filter ((/=) name << getName) model.streamer
            }
                ! [ LocalStorage.delete <| String.toLower name ]

        UpdateInputText s ->
            { model | inputText = s } ! []


updateStreamer : Int -> (b -> a -> b) -> a -> List b -> List b
updateStreamer idx f item xs =
    let
        updateItter count acc xs =
            case xs of
                x :: xs ->
                    if count == idx then
                        List.reverse acc ++ [ f x item ] ++ xs
                    else
                        updateItter (count + 1) (x :: acc) xs

                [] ->
                    List.reverse acc
    in
        updateItter 0 [] xs



-- REQUESTS


resolveStreamer : Streamer -> StreamerInfo (Maybe String) -> Streamer
resolveStreamer streamer { name, logoUrl, streamUrl, game, status } =
    let
        ogname =
            getName streamer
    in
        case ( name, logoUrl, streamUrl, game, status ) of
            ( Just name, Just logo, Just stream, Just game, Just status ) ->
                Online (StreamerInfo name logo stream game status)

            ( Just name, Just logo, _, _, _ ) ->
                Offline name logo

            ( _, _, _, _, _ ) ->
                Failure ogname


getName : Streamer -> String
getName s =
    case s of
        Init name ->
            name

        Online { name } ->
            name

        Offline name _ ->
            name

        Failure name ->
            name


requestStreamerInfo : Int -> String -> Cmd Msg
requestStreamerInfo idx name =
    let
        usersURL =
            "https://wind-bow.glitch.me/twitch-api/users/" ++ name

        streamsURL =
            "https://wind-bow.glitch.me/twitch-api/streams/" ++ name
    in
        Http.get usersURL usersDecoder
            |> Http.toTask
            |> Task.andThen
                (\p1 ->
                    Http.get streamsURL (streamsDecoder p1)
                        |> Http.toTask
                )
            |> Task.attempt (HandleResponse idx)


type alias StreamerPartial1 =
    Maybe String
    -> Maybe String
    -> Maybe String
    -> StreamerInfo (Maybe String)


usersDecoder : Decoder StreamerPartial1
usersDecoder =
    Decode.succeed StreamerInfo
        -- name
        |> andMap (nullableAt [ "display_name" ] Decode.string)
        -- Logo
        |> andMap (nullableAt [ "logo" ] Decode.string)


streamsDecoder : StreamerPartial1 -> Decoder (StreamerInfo (Maybe String))
streamsDecoder partial =
    Decode.succeed partial
        -- -- logoUrl
        -- |> andMap (nullableAt [ "stream", "preview", "medium" ] Decode.string)
        -- streamUrl
        |> andMap (nullableAt [ "stream", "channel", "url" ] Decode.string)
        -- game
        |> andMap (nullableAt [ "stream", "channel", "game" ] Decode.string)
        -- status
        |> andMap (nullableAt [ "stream", "channel", "status" ] Decode.string)


nullableAt : List String -> Decoder a -> Decoder (Maybe a)
nullableAt path decoder =
    let
        valueOrNothing input =
            case Decode.decodeValue (Decode.at path Decode.value) input of
                Ok item ->
                    case Decode.decodeValue (Decode.nullable decoder) item of
                        Ok result ->
                            Decode.succeed result

                        Err _ ->
                            Decode.succeed Nothing

                Err _ ->
                    Decode.succeed Nothing
    in
        Decode.value |> Decode.andThen valueOrNothing


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap da db =
    Decode.andThen (\b -> Decode.map b da) db



-- VIEW


view : Model -> Html Msg
view model =
    viewport stylesheet <|
        column Root
            [ width (percent 100)
            , height (percent 100)
            , center
            , verticalCenter
            ]
            [ column DPurpleBG
                [ width (px 850)
                , height (percent 90)
                , spacing 10
                , padding 10
                , center
                ]
                [ header model
                , Keyed.column WhiteBG
                    [ spacing 10
                    , padding 10
                    , width (percent 100)
                    , height fill
                    , clipX
                    , yScrollbar
                    ]
                    (List.map (keyedStreamerCard model.mode) <|
                        List.filter (byMode model.mode) model.streamer
                    )
                ]
            ]


header : Model -> Element Class Variation Msg
header model =
    row DPurpleBG
        [ height (px 100)
        , width (percent 100)
        , spacing 20
        , padding 10
        , alignLeft
        ]
        [ decorativeImage None
            [ height (percent 90)
            ]
            { src = "https://nmbrgts.github.io/images/Twitch_White_RGB.png" }
        , column
            None
            []
            [ el TitleText [ height (px 35) ] <| bold "Streamer Tracker"
            , row None
                [ height (px 40)
                , spacing 10
                , padding 10
                ]
                [ topBarButton model.mode "All" ViewAll
                , topBarButton model.mode "Online" ViewOnline
                , topBarButton model.mode "Offline" ViewOffline
                , topBarButton model.mode "Edit" Edit
                , if model.mode == Edit then
                    row LLPurpleBG
                        [ height (px 30)
                        , spacing 5
                        , padding 5
                        ]
                        [ button DPurpleBG
                            [ height (px 20)
                            , width (px 20)
                            , onClick (RequestStreamer model.inputText)
                            ]
                          <|
                            bold "+"
                        , Input.text
                            None
                            []
                            { onChange = UpdateInputText
                            , value = model.inputText
                            , label = Input.hiddenLabel "Input Streamer"
                            , options = []
                            }
                        ]
                  else
                    empty
                ]
            ]
        ]


topBarButton : Mode -> String -> Mode -> Element Class Variation Msg
topBarButton mode txt m =
    button TopBarButton
        [ height (px 30)
        , width (px 60)
        , vary Selected (mode == m)
        , onClick <| UpdateMode m
        ]
        (text txt)


byMode : Mode -> Streamer -> Bool
byMode mode streamer =
    case ( mode, streamer ) of
        ( ViewAll, _ ) ->
            True

        ( ViewOnline, Online _ ) ->
            True

        ( ViewOffline, Offline _ _ ) ->
            True

        ( Edit, _ ) ->
            True

        ( _, _ ) ->
            False


defaultLogo : String
defaultLogo =
    "https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png"


keyedStreamerCard :
    Mode
    -> Streamer
    -> ( String, Element Class Variation Msg )
keyedStreamerCard mode streamer =
    case streamer of
        Init name ->
            ( name
            , tileFormat mode False name defaultLogo [ "Fetching data..." ]
            )

        Online { name, logoUrl, streamUrl, game, status } ->
            ( name
            , tileFormat mode True name logoUrl [ game, status ]
            )

        Offline name logoUrl ->
            ( name
            , tileFormat mode False name logoUrl [ "Offline" ]
            )

        Failure name ->
            ( name
            , tileFormat mode
                False
                name
                defaultLogo
                [ "Failed to find streamer..." ]
            )


tileFormat :
    Mode
    -> Bool
    -> String
    -> String
    -> List String
    -> Element Class Variation Msg
tileFormat mode isOnline name logoUrl additionalLines =
    case mode of
        Edit ->
            row WhiteTile
                [ spacing 10
                , padding 10
                ]
                [ streamerIcon isOnline logoUrl
                , column None
                    [ spacing 5 ]
                  <|
                    [ el None [] (bold name)
                    ]
                        ++ List.map
                            (el None [] << text)
                            additionalLines
                , el None [ width fill, height fill ] <|
                    button DPurpleBG
                        [ alignRight
                        , width (px 20)
                        , height (px 20)
                        , padding 1
                        , onClick <| DeleteStreamer name
                        ]
                        (bold "X")
                ]

        _ ->
            link ("https://www.twitch.tv/" ++ name) <|
                row WhiteTile
                    [ spacing 10
                    , padding 10
                    ]
                    [ streamerIcon isOnline logoUrl
                    , column None
                        [ spacing 5 ]
                      <|
                        [ el None [] (bold name)
                        ]
                            ++ List.map
                                (el None [] << text)
                                additionalLines
                    ]


streamerIcon : Bool -> String -> Element Class Variation Msg
streamerIcon isOnline src =
    decorativeImage
        (if isOnline then
            OnlineIcon
         else
            None
        )
        [ width (px 100)
        , height (px 100)
        ]
        { src = src }
