module Syntax.TypeLevel.Reflection where

-- Reflection syntax
--  Converting a type-level instance into a value-level instance

-- This code...
----------------------------
type Value_Level_Type = String -- for easier readability

data CustomType = TypeInstance

reflectVL :: CustomType -> Value_Level_Type
reflectVL TypeInstance = "value-level instance"
----------------------------
-- ... converts to...
----------------------------
foreign import kind CustomKind
foreign import data CustomKindInstance :: CustomKind

data CustomKindProxy (a :: CustomKind) = CustomKindProxyInstance

-- "type-level instance to value-level instance"
class TLI_to_VLI (a :: CustomKind) where
  reflectCustomKind :: CustomKindProxy a -> Value_Level_Type

instance tli_to_vlI :: TLI_to_VLI CustomKindInstance where {-
  reflectCustomKind CustomKindProxyInstance = "value-level instance" -}
  reflectCustomKind _                       = "value-level instance"
----------------------------

-- An example using Booleans:
data Boolean_ = True_Value | False_Value

foreign import kind BooleanKind
foreign import data True :: BooleanKind
foreign import data False :: BooleanKind
data BooleanProxy (a :: BooleanKind) = BProxyInstance

{-
Read trueK and falseK as:
  trueK  = (BProxyInstance :: BProxy True) - an instance of type "BProxy True"
  falseK = (BProxyInstance :: BProxy False) - an instance of type "BProxy False" -}
trueK :: BooleanProxy True
trueK = BProxyInstance

falseK :: BooleanProxy False
falseK = BProxyInstance

class IsBooleanKind (a :: BooleanKind) where
  reflectBoolean :: BooleanProxy a -> Boolean

instance trueTL_VL :: IsBooleanKind True where
-- reflectBoolean (BProxyInstance :: BProxy True) = true
   reflectBoolean _                               = true

instance falseTL_VL :: IsBooleanKind False where
-- reflectBoolean (BProxyInstance :: BProxy False) = false
   reflectBoolean _                                = false


-- We can also use instance chains here to distinguish
-- one from another

class IsTrue (a :: BooleanKind) where
  isTrue :: BooleanProxy a -> Boolean

instance isTrue_True :: IsTrue True where
  isTrue _ = true
else instance isTrue_catchall :: IsTrue a where
  isTrue _ = false

-- Using instance chains here is more convenient if we had
-- a lot more type-level instances than just 2. In some cases,
-- it is needed in cases where a type-level type can have an
-- infinite number of instances, such as a type-level String

-- Open a REPL, import this module, and then run this code:
--    reflectBoolean trueK
--    reflectBoolean falseK
--    isTrue trueK
--    isTrue falseK
