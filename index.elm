import Html exposing (div, ul, li, text)
import Html.Attributes exposing (class)
import List exposing (sum, map, length)

inputs = ["first", "second", "third"]

main =
  ul [class "grocery-list"]
    [ li [] [text "Pamplemousse"]
    , li [] [text "Ananas"]
    , li [] [text "Jus d'orange"]
    , li [] [text "Boeuf"]
    , li [] [text "Soupe du jour"]
    , li [] [text "Camembert"]
    , li [] [text "Jacques Cousteau"]
    , li [] [text "Baguette"]
    ]

-- main =
--     div [
--       div [class "welcome-message"] [text "Hello, World! by jurgo"]
--     ]

-- renderList lst =
--     ul []
--         map (\l -> li [] [ text l ]) lst

-- main =
--   renderList
