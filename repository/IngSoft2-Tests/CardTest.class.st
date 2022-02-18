Class {
	#name : #CardTest,
	#superclass : #TestCase,
	#instVars : [
		'player1',
		'player2',
		'player3',
		'redoDeck',
		'speedDeck',
		'overloadDeck',
		'repeatDeck',
		'accelerationDeck',
		'cancellationDeck',
		'speedCard',
		'overloadCard',
		'accelerationCard',
		'repeatCard',
		'redoCard',
		'cancellationCard',
		'boostDeck'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'testing - messages' }
CardTest >> generateDefaultGame [

	| aDie aBoard aDice |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 6.
	^ BigTalkGame
		  playedBy: { 
				  player1.
				  player2 }
		  usingDice: aDice
		  playedOn: aBoard
		  finishingAtLap: 1
		  usingDeck: Deck default.
]

{ #category : #'testing - messages' }
CardTest >> generateEffectTestingGameWithBoardSlots: boardslots andDice: aDie [

	| aBoard aDice |
	
	aDice := Dice with: {aDie}.
	aBoard := Board withAll: boardslots.
	^ BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 2
		usingDeck: Deck default.
]

{ #category : #'testing - messages' }
CardTest >> generateGameWithDeck: aDeck [

	| aDie aBoard aDice |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 6.
	^ BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: aDeck.
]

{ #category : #running }
CardTest >> setUp [

	player1 := Player named: 'Gaspar'.
	player2 := Player named: 'Martin'.
	player3 := Player named: 'Carla'.
	redoDeck := TestingDeck onlyRedoCards.
	speedDeck := TestingDeck onlySpeedCards.
	overloadDeck := TestingDeck onlyOverloadCards.
	repeatDeck := TestingDeck onlyRepeatCards.
	accelerationDeck := TestingDeck onlyAccelerationCards.
	cancellationDeck := TestingDeck onlyCancellationCards.
	boostDeck := TestingDeck onlyBoostCards.
	speedCard := Speed new.
	overloadCard := Overload new.
	accelerationCard := Acceleration new.
	repeatCard := Repeat new.
	redoCard := Redo new.
	cancellationCard := Cancellation new
]

{ #category : #assertions }
CardTest >> should: anErrorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
CardTest >> testAGamePlayerPlaysCardNotInHand [

	| aGame aDie aBoard aDice |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 6.
	aGame := self generateGameWithDeck: TestingDeck onlyOverloadCards .
	self
		should: [ aGame speedCardUsedBy: player1 targetting: player2. ]
		raise: Error
		withMessage: 'The player does not have that card'
]

{ #category : #tests }
CardTest >> testAGameUsingCardWhenFinished [


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
		usingDeck: TestingDeck onlySpeedCards.
	
	aGame moveCurrentPlayer.
	self
		should: [ aGame speedCardUsedBy: player2 targetting: player1. ]
		raise: Error
		withMessage: 'The game has finished' .
	
	
	
]

{ #category : #tests }
CardTest >> testAGameWithACancellationAndNoActiveCards [

	| aGame aLeader |
	player1 drawCardFrom: speedDeck.
	player1 drawCardFrom: cancellationDeck.
	aGame := self generateDefaultGame.
	self
		should: [ aGame cancellationCardUsedBy: player1 targetting: player2 removing: speedCard .]
		raise: Error
		withMessage: 'Cant play cancellation with no active cards in game'.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: aLeader equals: 4
]

{ #category : #tests }
CardTest >> testAGameWithACancellationOnCardNotUsed [

	| aGame |
	player1 drawCardFrom: speedDeck.
	player1 drawCardFrom: cancellationDeck.
	aGame := self generateDefaultGame.
	aGame speedCardUsedBy: player1 targetting: player1.
	self
		should: [ aGame cancellationCardUsedBy: player1 targetting: player1 removing: overloadCard .]
		raise: Error
		withMessage: 'The player does not have that card active'.
	
	
]

{ #category : #tests }
CardTest >> testAGameWithASpeedCard [

	| aGame aLeader |
	player1 drawCardFrom: speedDeck.
	aGame := self generateDefaultGame.
	aGame speedCardUsedBy: player1 targetting: player1.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: aLeader equals: 5
]

{ #category : #tests }
CardTest >> testAGameWithASpeedCardAndBoost [

	| aGame aLeader |
	player1 drawCardFrom: speedDeck.
	player1 drawCardFrom: boostDeck.
	aGame := self generateDefaultGame.
	aGame speedCardUsedBy: player1 targetting: player1.
	aGame boostCardUsedBy: player1 targetting: player1 boosting: speedCard.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: aLeader equals: 6
]

{ #category : #tests }
CardTest >> testAGameWithASpeedCardAndCancellation [

	| aGame aLeader |
	player1 drawCardFrom: speedDeck.
	player1 drawCardFrom: cancellationDeck.
	aGame := self generateDefaultGame.
	aGame speedCardUsedBy: player1 targetting: player1.
	aGame cancellationCardUsedBy: player1 targetting: player1 removing: speedCard.
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: aLeader equals: 4
]

{ #category : #tests }
CardTest >> testAGameWithAnAccelerationCard [

	| aGame |
	player1 drawCardFrom: accelerationDeck.
	
	aGame := self generateDefaultGame.
	aGame accelerationCardUsedBy: player1.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player2) equals: 5
]

{ #category : #tests }
CardTest >> testAGameWithAnInstantRepeatCardWithLastEffectAtomicBomb [

	| aGame aDie aLeaderPosition someSlots |
	
	aDie := LoadedDie rolling: 8.
	someSlots := {
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withNoEffect.
		BoardSlot withAtomicBomb
	}.
	
	aGame := self generateEffectTestingGameWithBoardSlots: someSlots  andDice: aDie.
	player2 drawCardFrom: repeatDeck.
	aGame moveCurrentPlayer.
	aGame repeatCardUsedBy: player2 targetting: player1.
	aLeaderPosition := aGame leaderPosition.
	self assert: aLeaderPosition equals: 0
]

{ #category : #tests }
CardTest >> testAGameWithAnInstantRepeatCardWithLastEffectMoonwalk [

	| aGame aDie someSlots |
	
	aDie := LoadedDie rolling: 4.
	someSlots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withNoEffect}.

	aGame := self generateEffectTestingGameWithBoardSlots: someSlots andDice: aDie.
	player2 drawCardFrom: repeatDeck.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 4.
	self assert: (aGame currentSlotOf: player2) equals: 0.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 4.
	self assert: (aGame currentSlotOf: player2) equals: 4.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 8.
	self assert: (aGame currentSlotOf: player2) equals: 2.
	aGame repeatCardUsedBy: player2 targetting: player1.
	self assert: (aGame currentSlotOf: player1) equals: 8.
	self assert: (aGame currentSlotOf: player2) equals: 0
]

{ #category : #tests }
CardTest >> testAGameWithAnInstantRepeatCardWithLastEffectSpeedUp [

	| aGame aDie aLeaderPosition someSlots |
	
	aDie := LoadedDie rolling: 3.
	someSlots := {BoardSlot withNoEffect.
	BoardSlot withWormHole.
	BoardSlot withSpeedUp.
	BoardSlot withMoonwalkWithTwoStepsBack.
	BoardSlot withAtomicBomb.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect}.
	
	
	aGame := self generateEffectTestingGameWithBoardSlots: someSlots andDice: aDie.
	player2 drawCardFrom: repeatDeck.
	aGame moveCurrentPlayer.
	aGame repeatCardUsedBy: player2 targetting: player1.
	aLeaderPosition := aGame leaderPosition.
	self assert: aLeaderPosition equals: 11
]

{ #category : #tests }
CardTest >> testAGameWithAnInstantRepeatCardWithLastEffectWormHole [

	| aGame aDie aLeaderPosition someSlots |
	
	aDie := LoadedDie rolling: 4.
	someSlots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withWormHole}.
	
	
	aGame := self generateEffectTestingGameWithBoardSlots: someSlots andDice: aDie.
	player2 drawCardFrom: repeatDeck.
	3 timesRepeat: [ aGame moveCurrentPlayer ].
	aGame repeatCardUsedBy: player2 targetting: player1.
	aLeaderPosition := aGame leaderPosition.
	self assert: aLeaderPosition equals: 4.
	self assert: (aGame currentSlotOf: player1) equals: 0
]

{ #category : #tests }
CardTest >> testAGameWithAnOverloadCard [

	| aGame |
	player1 drawCardFrom: overloadDeck.
	aGame := self generateDefaultGame.
	aGame overloadCardUsedBy: player1 targetting: player1.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 2.
	self assert: (aGame currentSlotOf: player2) equals: 4
]

{ #category : #tests }
CardTest >> testAGameWithAnOverloadCardAndBoost [

	| aGame aDie aDice aBoard aLeader |
	player1 drawCardFrom: overloadDeck.
	player1 drawCardFrom: boostDeck.
	aDie := LoadedDie rolling: 8.
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
	aGame overloadCardUsedBy: player1 targetting: player1.
	aGame boostCardUsedBy: player1 targetting: player1 boosting: overloadCard .
	aGame moveCurrentPlayer.
	aLeader := aGame leaderPosition.
	self assert: aLeader equals: 4
]

{ #category : #tests }
CardTest >> testAGameWithAnOverloadCardOnTwoPlayers [

	| aGame |
	player1 drawCardFrom: overloadDeck.
	aGame := self generateDefaultGame.
	self
		should: [ aGame overloadCardUsedBy: player1 targetting: {player1.player2}. ]
		raise: Error
		withMessage: 'This card can only be played on 1 player'.
]

{ #category : #tests }
CardTest >> testAGameWithAnSpeedCardOnTwoPlayers [

	| aGame |
	player1 drawCardFrom: speedDeck .
	aGame := self generateDefaultGame.
	self
		should: [ aGame speedCardUsedBy: player1 targetting: {player1.player2} ]
		raise: Error
		withMessage: 'This card can only be played on 1 player'.
]

{ #category : #tests }
CardTest >> testAGameWithDoubleRedoAnAcceleration [
	| aGame aDie aBoard aDice allPlayers |
	player1 drawCardFrom: accelerationDeck.
	player1 drawCardFrom: redoDeck.
	player1 drawCardFrom: redoDeck.
	allPlayers := {player1.
	player2}.
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 20.
	aGame := BigTalkGame
		playedBy: allPlayers
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: Deck default.
	aGame accelerationCardUsedBy: player1.
	aGame redoCardUsedBy: player1.
	aGame redoCardUsedBy: player1.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 7.
	self assert: (aGame currentSlotOf: player2) equals: 7
]

{ #category : #tests }
CardTest >> testAGameWithRedoAnAcceleration [

	| aGame |
	
	aGame := self generateDefaultGame .
	player1 drawCardFrom: accelerationDeck.
	player1 drawCardFrom: redoDeck.
	aGame accelerationCardUsedBy: player1.
	aGame redoCardUsedBy: player1.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 6.
	self assert: (aGame currentSlotOf: player2) equals: 6
]

{ #category : #tests }
CardTest >> testAGameWithRedoAnOverload [

	| aGame |
	
	aGame := self generateDefaultGame.
	player1 drawCardFrom: overloadDeck.
	player1 drawCardFrom: redoDeck.
	aGame overloadCardUsedBy: player1 targetting: player1.
	aGame redoCardUsedBy: player1 targetting: player2.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 2.
	self assert: (aGame currentSlotOf: player2) equals: 2
]

{ #category : #tests }
CardTest >> testAGameWithRedoWithNoPreviousCards [

	| aGame |
	aGame := self generateDefaultGame.
	player1 drawCardFrom: accelerationDeck.
	player1 drawCardFrom: redoDeck.


	self
		should: [ aGame redoCardUsedBy: player1 ]
		raise: Error
		withMessage: 'No available card for Redo'.


	
]

{ #category : #tests }
CardTest >> testPlayerApplyACardAtBeginning [

	| aGame aDie aBoard aDice slots |
	aDie := LoadedDie rolling: 2.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withGrabCard.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: speedDeck .
	aGame speedCardUsedBy: player1 targetting: player2. 
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 2.
	self assert: (aGame currentSlotOf: player2) equals: 3.
]

{ #category : #tests }
CardTest >> testPlayerCantPlayPermanentCardsOutsideTurn [

	| aGame |
	
	aGame := self generateDefaultGame .
	aGame moveCurrentPlayer.
	self
		should: [ aGame speedCardUsedBy: player1 targetting: player2 ]
		raise: Error
		withMessage: 'Players can only play permanent cards during their turn'.

]

{ #category : #tests }
CardTest >> testPlayerFallsOnGrabCardGrabsSpeed [

	| aGame aDie aBoard aDice slots |
	aDie := LoadedDie rolling: 2.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withGrabCard.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: TestingDeck onlySpeedCards.
	aGame speedCardUsedBy: player1 targetting: player2.
	aGame speedCardUsedBy: player1 targetting: player2.
	self
		should: [ aGame speedCardUsedBy: player1 targetting: player2 ]
		raise: Error
		withMessage: 'The player does not have any cards left'.
	aGame moveCurrentPlayer.
	self
		should: [ aGame speedCardUsedBy: player1 targetting: player2  ]
		raise: Error
		withMessage: 'Players can only play permanent cards during their turn'.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	aGame speedCardUsedBy: player1 targetting: player2 .
	aGame moveCurrentPlayer.
	aGame moveCurrentPlayer.
	self assert: (aGame currentSlotOf: player1) equals: 6.
	self assert: (aGame currentSlotOf: player2) equals: 5
]

{ #category : #tests }
CardTest >> testPlayerStartsWithTwoCards [

	| aGame aDie aBoard aDice slots |
	aDie := LoadedDie rolling: 2.
	aDice := Dice with: {aDie}.
	slots := {BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withGrabCard.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect.
	BoardSlot withNoEffect}.
	aBoard := Board withAll: slots.
	aGame := BigTalkGame
		playedBy:
			{player1.
			player2}
		usingDice: aDice
		playedOn: aBoard
		finishingAtLap: 1
		usingDeck: speedDeck .
	aGame speedCardUsedBy: player1 targetting: player2.
	aGame speedCardUsedBy: player1 targetting: player2.
	self
		should: [ aGame speedCardUsedBy: player1 targetting: player2]
		raise: Error
		withMessage: 'The player does not have any cards left'.
]
