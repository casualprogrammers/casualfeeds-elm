import Html exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json
import Task


-- initialisation
main =
  Html.program
    { init = init "Casual feed"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { title : String
  , content : String
  }


init : String -> (Model, Cmd Msg)
init title =
  ( Model title "Loading"
  , getFeed "https://www.reddit.com/r/all.json"
  )



-- UPDATE


type Msg
  = FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchSucceed newUrl ->
      (Model model.title newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.title]
    , br [] []
    , p [] [text model.content]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getFeed : String -> Cmd Msg
getFeed url = Task.perform FetchFail FetchSucceed (Http.get decodeResponse url)

decodeResponse : Json.Decoder String
decodeResponse =
  Json.at ["data", "after"] Json.string
