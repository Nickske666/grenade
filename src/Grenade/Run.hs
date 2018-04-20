{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}

module Grenade.Run
    ( run
    ) where

import Grenade.Train.Network
import Grenade.Train.DataSet

import Data.Singletons (SingI)
import Data.Singletons.Prelude (Last, Head)

import Grenade.Core (Shape, LearningParameters, Network)

import Control.Monad

run
    :: forall (shapes :: [Shape]) (layers :: [*]) (i :: Shape) (o :: Shape)
    . (SingI o, i ~ Head shapes, o ~ Last shapes)
    => Int
    -> LearningParameters
    -> IO (Network layers shapes)
    -> IO (DataSet i o, DataSet i o, DataSet i o)
    -> IO ()
run epochs param networkM loadData = do
    (trainSet, valSet, testSet) <- loadData
    net0 <- networkM
    void $ trainNetworkAndPrintAccuracies epochs param trainSet valSet testSet net0
