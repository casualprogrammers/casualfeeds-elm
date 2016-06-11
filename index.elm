import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task


feedsUrl = "https://www.reddit.com/r/all.json"



decodeFeedsUrl : Json.Decoder String
decodeFeedsUrl =
  Json.at ["data", "image_url"] Json.string


getFeeds : String -> Cmd Msg
getFeeds url =
    Task.perform FetchFail FetchSucceed (Http.get decodeFeedsUrl url)

type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error


type alias Model =
  { topic : String
  , gifUrl : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif"
  , getFeeds feedsUrl
  )



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getFeeds model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)


listModel =
  ["Pamplemousse" ,"Ananas", "Jus d'orange", "Boeuf"]
listItem txt = li [] [text txt]
main =
  ul
    [class "grocery-list"]
    (List.map (listItem) listModel  )
