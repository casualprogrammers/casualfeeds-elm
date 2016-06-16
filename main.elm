import Html exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json exposing (..)
import Task


-- initialisation
main: Program Never
main =
  Html.program
    { init = init "Casual feed" ["Loading"]
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { title : String
  , feeds: List String
  }


init : String -> List String-> (Model, Cmd Msg)
init title feeds =
  ( Model title feeds
  , getFeed "https://www.reddit.com/r/all.json"
  )



-- UPDATE


type Msg
  = FetchSucceed (List String)
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchSucceed  feeds ->
      (Model model.title feeds, Cmd.none)

    FetchFail _ ->
      (Model "fail" model.feeds, Cmd.none)



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
getFeed url = 
  url
  |> Http.get decodeResponse 
  |> Task.perform FetchFail FetchSucceed 


-- decoders


decodeResponse : Json.Decoder (List String)
decodeResponse = Json.at ["data", "children"] (Json.list Json.string)
   -- let 
    --  feeds = Json.object1 (\kind -> kind) ("kind" := string)
    --in
     -- "children" := Json.at ["data", "children"] feeds
