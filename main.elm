import Html exposing (..)
import Html.App as Html
import Http
import Json.Decode exposing (..)
import Task


-- initialisation
main: Program Never
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
  , feeds: List String
  }


init : String -> (Model, Cmd Msg)
init title =
  ( Model title ["Loading"]
  , getFeed "https://www.reddit.com/r/all.json"
  )



-- UPDATE


type Msg
  = FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchSucceed  _ ->
      (model, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)



-- VIEW
listItem : String -> Html msg
listItem txt = li [] [text txt]

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.title]
    , br [] []
    , p [] (List.map (listItem) model.feeds)
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getFeed : String -> Cmd Msg
getFeed url = Task.perform FetchFail FetchSucceed (Http.get decodeResponse url)

fullNameDecoder : Decoder String
fullNameDecoder =
  object1 identity ("kind" := string)

decodeResponse : Decoder String
decodeResponse = at ["data", "children"] fullNameDecoder
