import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task

feedsUrl = "https://www.reddit.com/r/all.json"

main =
  Html.program
    { init = init "feeds"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , feeds: List String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "loading..." ["is1", "item2"]
  , getRandomGif topic
  )



-- UPDATE

type alias Response = {
  newUrl : String,
  feeds: List String
}

type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)


    FetchSucceed newUrl  ->
      (Model model.topic newUrl ["cane", "volante", "maggiore"], Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , h3 [] [text model.gifUrl]
    , ul
      [class "grocery-list"]
      (List.map (listItem) model.feeds  )

    ]

listItem txt = li [] [text txt]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      feedsUrl
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "after"] Json.string
