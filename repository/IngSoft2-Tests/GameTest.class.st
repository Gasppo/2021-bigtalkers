Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#instVars : [
		'player1',
		'player2',
		'player3'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
GameTest >> setUp [

	player1 := Player named: 'Gaspar'.
	player2 := Player named: 'Martin'.
	player3 := Player named: 'Carla'
]

{ #category : #assertions }
GameTest >> should: anErrorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
GameTest >> testAGameWithNegativeFinishingLap [

	| aDice aBoard |
	aDice := Dice with: {(Die withSides: 4)}.
	aBoard := Board sizedWithNoEffects: 4.
	self
		should: [ BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: -1
		usingDeck: Deck default. ]
		raise: Error
		withMessage: 'You need at least one lap per game' .

]

{ #category : #tests }
GameTest >> testAGameWithScoreboardGetLeaderUsingRoll [

	| aGame aDie aBoard aDice aLeader |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 6.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: (aLeader between: 1 and: 4)
]

{ #category : #tests }
GameTest >> testAGameWithScoreboardMovesForward [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 2.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: ((aGame currentSlotOf: player1) between: 1 and: 4).
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
GameTest >> testAGameWithTwoPlayersAndADieAndABoardHasNotFinished [

	| aGame aDice aBoard |
	aDice := Dice with: {(Die withSides: 4)}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	self deny: aGame hasFinished
]

{ #category : #tests }
GameTest >> testCannotCreateAGameWithNoPlayers [

	| aDie aDice aBoard |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	self
		should: [ BigTalkGame
				playedBy: {}
				usingDice: aDice
				playedOn: aBoard
				finishingAtLap: 1
				usingDeck: Deck default. ]
		raise: Error
		withMessage: 'You need at least one player to play'
]

{ #category : #tests }
GameTest >> testCheckLeaderName [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: aGame leader equals: player1
]

{ #category : #tests }
GameTest >> testCheckPlayerLapAndPositionAfterMoving [

	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 15.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	10 timesRepeat: [ aGame moveCurrentPlayer ].
	self assert: (aGame currentLapOf: player1) equals: 1.
	self assert: (aGame currentSlotOf: player1) equals: 1
]

{ #category : #tests }
GameTest >> testCheckPlayerPosition [


	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 20.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player2) equals: 4
]

{ #category : #tests }
GameTest >> testCheckPlayerPositionForPlayerNotInGame [


	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 20.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self should: [ (aGame currentSlotOf: player3) equals: 4. ]
		raise: Error
		withMessage: 'That player is not in the game'.
]

{ #category : #tests }
GameTest >> testCheckPlayerPositionsWithATie [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame rankOf: player2) equals: 2
]

{ #category : #tests }
GameTest >> testCheckPlayerTurn [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	self assert: aGame currentTurnPlayer equals: player1
]

{ #category : #tests }
GameTest >> testCheckPlayerTurnAfterMove [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: aGame currentTurnPlayer equals: player2
]

{ #category : #tests }
GameTest >> testCheckRankingPositions [

	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 5.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame rankOf: player2) equals: 2
]

{ #category : #tests }
GameTest >> testCreateAGameWithDefaultValues [

	| aGame aLeader aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: (aLeader between: 1 and: 4)
]

{ #category : #tests }
GameTest >> testCreateAGameWithScoreboard [

	| aGame aDice aBoard |
	aDice := Dice with: {(Die withSides: 4)}.
	aBoard := Board sizedWithNoEffects: 2.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	self assert: (aGame currentSlotOf: player1) equals: 0.
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
GameTest >> testGameControlledMovement [

	| aGame aDie aDice aBoard |
	aDie := Die withSides: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 20.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: aGame currentTurnPlayer equals: player1
]

{ #category : #tests }
GameTest >> testGameCreatedUsingFixedSlotsFinishedWithTwoLaps [

	| aGame aDie aDice aBoard slots |
	aDie := LoadedDie rolling: 6.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 2
		usingDeck: Deck default.
	7 timesRepeat: [ aGame moveCurrentPlayer ].
	self assert: aGame leader equals: player1.
	self
		should: [ aGame moveCurrentPlayer ]
		raise: Error
		withMessage: 'The game has finished'
]

{ #category : #tests }
GameTest >> testGameFinishedAndStillMovePlayer [

	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 5.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self
		should: [ aGame moveCurrentPlayer ]
		raise: Error
		withMessage: 'The game has finished'
]

{ #category : #tests }
GameTest >> testGameFinishedWithTwoLaps [

	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 5.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 2
		usingDeck: Deck default.
	4 timesRepeat: [ aGame moveCurrentPlayer ].
	self
		should: [ aGame moveCurrentPlayer ]
		raise: Error
		withMessage: 'The game has finished'
]

{ #category : #tests }
GameTest >> testGameFinishedWithWinner [

	| aGame aDie aDice aBoard |
	aDie := LoadedDie rolling: 6.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 5.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2.
			player3}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: aGame hasFinished.
	self assert: aGame leader equals: player1
]

{ #category : #tests }
GameTest >> testGamePlayerOneFallsInAtomicBomb [

	| aDie aDice aBoard aGame slots |
	aDie := LoadedDie rolling: 5.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 0.
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
GameTest >> testGamePlayerOneFallsInMoonWalk [

	| aDie aDice aBoard aGame slots |
	slots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withMoonwalkWithTwoStepsBack}.
	aBoard := Board withAll: slots.
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 4
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame currentLapOf: player1) equals: 1.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 2.
	self assert: (aGame currentSlotOf: player2) equals: 0.
	self assert: (aGame currentLapOf: player1) equals: 0.
	self assert: (aGame currentLapOf: player2) equals: 1
]

{ #category : #tests }
GameTest >> testGamePlayerOneFallsInMoonWalkAndWouldHaveNegativeLaps [

	| aDie aDice aBoard aGame slots |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 4.
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
GameTest >> testGamePlayerOneFallsInSpeedUp [

	| aDie aDice aBoard aGame slots |
	aDie := LoadedDie rolling: 3.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 3
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 1.
	self assert: (aGame currentLapOf: player1) equals: 1.
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
GameTest >> testGamePlayerOneFallsInWormhole [

	| aDie aDice aBoard aGame slots |
	aDie := LoadedDie rolling: 6.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withWormHole}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 2
]

{ #category : #tests }
GameTest >> testGameWithTwoPlayersWithSameName [

	| aDie aDice aBoard |
	player2 := Player named: 'Carla'.
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 4.
	self
		should: [ BigTalkGame
				playedBy:
					{player1.
					player2.
					player3}
				usingDice: aDice
				playedOn: aBoard
				finishingAtLap: 1
				usingDeck: Deck default. ]
		raise: Error
		withMessage: 'There can not be two players with the same name'
]
