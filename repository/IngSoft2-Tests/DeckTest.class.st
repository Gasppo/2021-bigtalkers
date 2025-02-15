Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#instVars : [
		'player1',
		'player2',
		'player3',
		'speedCard',
		'overloadCard',
		'accelerationCard',
		'repeatCard',
		'redoCard',
		'cancellationCard',
		'redoDeck',
		'speedDeck',
		'overloadDeck',
		'repeatDeck',
		'accelerationDeck',
		'cancellationDeck',
		'boostDeck'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'testing - messages' }
DeckTest >> certainDistributionOf: anItem [

	| eventDistribution |
	eventDistribution := OrderedCollection new.
	eventDistribution add:
		(DiscreteProbabilityEvent of: anItem havingProbability: 1).
		^eventDistribution 
]

{ #category : #'testing - messages' }
DeckTest >> generateDefaultGame [

	| aDie aBoard aDice |
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: { aDie }.
	aBoard := Board sizedWithNoEffects: 6.
	^ BigTalkGame
		  playedBy: { 
				  player1.
				  player2 }
		  usingDice: aDice
		  playedOn: aBoard
		  finishingAtLap: 1
		  usingDeck: Deck default
]

{ #category : #'testing - messages' }
DeckTest >> generateGameWithDeck: aDeck [

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

{ #category : #'testing - messages' }
DeckTest >> setUp [

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
DeckTest >> should: anErrorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
DeckTest >> testDeckAddCards [
	| aDeck accelerationCertain| 
	accelerationCertain := self certainDistributionOf: accelerationCard .
		
	aDeck := Deck withProbabilities: accelerationCertain usingCardAmount: 2.
	self assert: aDeck cardsRemaining equals: 2.
	aDeck addCard: Acceleration new.
	self assert: aDeck cardsRemaining equals: 3.
]

{ #category : #tests }
DeckTest >> testDeckPlayerTriesToDrawEmpty [
	| aDeck accelerationCertain| 
	
	accelerationCertain := self certainDistributionOf: accelerationCard .
	aDeck := Deck withProbabilities: accelerationCertain usingCardAmount: 0.
	self
		should: [ player1 drawCardFrom: aDeck]
		raise: Error
		withMessage: 'Cant draw from empty deck'.
]

{ #category : #tests }
DeckTest >> testDeckRemoveByDrawingCards [
	| aDeck accelerationCertain card1 card2| 
	accelerationCertain := self certainDistributionOf: accelerationCard .
		
	aDeck := Deck withProbabilities: accelerationCertain usingCardAmount: 2.
	card1 := aDeck drawWithoutReposition.
	self assert: aDeck cardsRemaining equals: 1.
	card2 := aDeck drawWithoutReposition.
	self assert: aDeck cardsRemaining equals: 0.
]

{ #category : #tests }
DeckTest >> testDeckStartsEmpty [
	| aDeck accelerationCertain| 
	
	accelerationCertain := self certainDistributionOf: accelerationCard .
	aDeck := Deck withProbabilities: accelerationCertain usingCardAmount: 0.
	^self assert: aDeck cardsRemaining equals: 0.
]

{ #category : #tests }
DeckTest >> testDiscardDeckHasTwoCards [
	| aGame aDie aBoard aDice |
	
	player1 drawCardFrom: speedDeck.
	player1 drawCardFrom: cancellationDeck.
	aDie := LoadedDie rolling: 4.
	aDice := Dice with: {aDie}.
	aBoard := Board sizedWithNoEffects: 6.
	aGame := self generateDefaultGame.
	aGame speedCardUsedBy: player1 targetting: player1.
	aGame cancellationCardUsedBy: player1 targetting: player1 removing: speedCard.
	self assert: aGame discardDeckSize equals: 2.
]

{ #category : #tests }
DeckTest >> testGamePlayerTriesToDrawEmptyDeckAndDiscard [

	| repeatDistribution fourCardRepeatDeck aGame |
	repeatDistribution := self certainDistributionOf: repeatCard.
	fourCardRepeatDeck := Deck withProbabilities: repeatDistribution usingCardAmount: 4.

	aGame := self generateGameWithDeck: fourCardRepeatDeck .
	
	self
		should: [ aGame drawFromDeck: player1.]
		raise: Error
		withMessage: 'Cant draw from empty deck, and discard deck is empty'.

]

{ #category : #tests }
DeckTest >> testGameWithoutEnoughCardsOnDeckToStart [

	| repeatDistribution fourCardRepeatDeck |
	repeatDistribution := self certainDistributionOf: repeatCard.
	fourCardRepeatDeck := Deck withProbabilities: repeatDistribution usingCardAmount: 3.

	
	self
		should: [ self generateGameWithDeck: fourCardRepeatDeck . ]
		raise: Error
		withMessage: 'Not enough cards in deck to start game'.

]

{ #category : #tests }
DeckTest >> testRebuildingDeckFromDiscard [

	| repeatDistribution fiveCardRepeatDeck aGame |
	repeatDistribution := self certainDistributionOf: repeatCard.
	fiveCardRepeatDeck := Deck withProbabilities: repeatDistribution usingCardAmount: 5.

	aGame := self generateGameWithDeck: fiveCardRepeatDeck .
	aGame repeatCardUsedBy: player1 targetting: player1.
	aGame repeatCardUsedBy: player1 targetting: player1.
	aGame moveCurrentPlayer.
	aGame repeatCardUsedBy: player2  targetting: player1.
	aGame repeatCardUsedBy: player2 targetting: player1.
	self assert: aGame cardsRemainingOnDeck equals: 1.
	aGame drawFromDeck: player1.
	self assert: aGame cardsRemainingOnDeck equals: 0.
	aGame drawFromDeck: player1.
	self assert: aGame cardsRemainingOnDeck equals: 3
	
]
