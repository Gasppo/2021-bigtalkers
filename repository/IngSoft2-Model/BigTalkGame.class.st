Class {
	#name : #BigTalkGame,
	#superclass : #Object,
	#instVars : [
		'cardController',
		'players',
		'dice',
		'board',
		'scoreboard',
		'turn',
		'currentPlayer',
		'lastEffect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
BigTalkGame class >> assertAtLeastOneLap: lapNumber [

	lapNumber > 0
		ifFalse: [ Error signal: 'You need at least one lap per game' ]
]

{ #category : #validation }
BigTalkGame class >> assertAtLeastOnePlayer: somePlayers [

	somePlayers isEmpty
		ifTrue: [ Error signal: 'You need at least one player to play' ]
]

{ #category : #validation }
BigTalkGame class >> assertEnoughCardsOn: aDeck toStartWith: somePlayers [ 
	aDeck cardsRemaining >= ((somePlayers size) * 2) 
		ifFalse: [ Error signal: 'Not enough cards in deck to start game' ]
]

{ #category : #assertions }
BigTalkGame class >> assertNoDuplicatePlayers: somePlayers [

	| somePlayersNames |
	somePlayersNames := Set
		withAll: (somePlayers collect: [ :player | player playerName ]).
	somePlayers size ~= somePlayersNames size
		ifTrue: [ Error signal: 'There can not be two players with the same name' ]
]

{ #category : #'instance creation' }
BigTalkGame class >> playedBy: somePlayers usingDice: someDice playedOn: aBoard finishingAtLap: aLapNumber usingDeck: aDeck [

	| parameters |
	parameters := OrderedCollection withAll: { somePlayers.someDice.aBoard.aLapNumber.aDeck }.
	self validateParameters: parameters.

	^ self new
		  initializeWithPlayers: somePlayers
		  withDice: someDice
		  withBoard: aBoard
		  finishingAtLap: aLapNumber
		  withDeck: aDeck
]

{ #category : #validation }
BigTalkGame class >> validateParameters: parameterCollection [
	|somePlayers  someDice  aBoard  aLapNumber  aDeck|
	
	somePlayers := parameterCollection at: 1.
	someDice := parameterCollection at: 2.
	aBoard := parameterCollection at: 3.
	aLapNumber := parameterCollection at: 4.
	aDeck := parameterCollection at: 5.
	
	
	self assertAtLeastOnePlayer: somePlayers .
	self assertNoDuplicatePlayers: somePlayers .
	self assertAtLeastOneLap: aLapNumber.
	self assertEnoughCardsOn: aDeck toStartWith: somePlayers  
]

{ #category : #'playing - card usage' }
BigTalkGame >> accelerationCardUsedBy: aPlayer [ 

self player: aPlayer usesCard: Acceleration new  on: players.
self addCardToDiscardDeck: Acceleration new .
]

{ #category : #'accessing - game' }
BigTalkGame >> activeCardStack [

	^ cardController activeCardStack  
]

{ #category : #private }
BigTalkGame >> addActiveCard: aCard on: target [

	cardController addActiveCard: aCard on: target. 
]

{ #category : #private }
BigTalkGame >> addCardToDiscardDeck: aCard [

	cardController addToDiscardDeck: aCard
]

{ #category : #'effect-application' }
BigTalkGame >> applyAtomicBombTo: aPlayer [

	players do: [ :player | self playerMoveToStart: player ]
]

{ #category : #'effect-application' }
BigTalkGame >> applyCurrentEffect [

	^ board applyEffectTo: self toPlayer: self currentTurnPlayer
]

{ #category : #'effect-application' }
BigTalkGame >> applyGrabCardTo: aPlayer [

	self drawFromDeck: aPlayer
]

{ #category : #'effect-application' }
BigTalkGame >> applyLastCardTo: target [

	cardController lastCardUsed applyOn: self to: target
]

{ #category : #'effect-application' }
BigTalkGame >> applyLastEffectTo: target [

	lastEffect applyTo: self triggeredBy: target
]

{ #category : #'effect-application' }
BigTalkGame >> applyMoonWalk: steps toPlayer: target [

	self playerMove: target slots: steps.
	players do: [ :player | self playerMove: player slots: steps * -1 ]
]

{ #category : #'effect-application' }
BigTalkGame >> applySpeedUpTo: aPlayer [

	self playerMove: aPlayer slots: 4
]

{ #category : #'effect-application' }
BigTalkGame >> applyWormHoleTo: aPlayer [

	self playerMove: aPlayer slots: -4
]

{ #category : #assertions }
BigTalkGame >> assertGameIsNotFinished [

	self hasFinished ifTrue: [ Error signal: 'The game has finished' ]
]

{ #category : #'effect-application' }
BigTalkGame >> boostActiveCard: aCard from: target [

	cardController boost: aCard from: target
]

{ #category : #'playing - card usage' }
BigTalkGame >> boostCardUsedBy: aPlayer targetting: target boosting: aBoostedCard [ 

self player: aPlayer usesCard: Boost new  on: {aBoostedCard.target}.
self addCardToDiscardDeck: Boost new .

]

{ #category : #'playing - card usage' }
BigTalkGame >> cancellationCardUsedBy: aPlayer targetting: target removing: aCancelledCard [ 

self player: aPlayer usesCard: Cancellation new  on: {aCancelledCard.target}.
self addCardToDiscardDeck: Cancellation new .
self addCardToDiscardDeck: aCancelledCard .
]

{ #category : #'accessing - deck' }
BigTalkGame >> cardsRemainingOnDeck [
	^cardController remainingOnMainDeck
]

{ #category : #playing }
BigTalkGame >> changeTurn [

	turn nextPut: currentPlayer.
	currentPlayer := turn next
]

{ #category : #'accessing - player' }
BigTalkGame >> currentLapOf: aPlayer [

	^ board currentLapOf: aPlayer
]

{ #category : #'accessing - player' }
BigTalkGame >> currentSlotOf: aPlayer [

	^ board currentSlotOf: aPlayer
]

{ #category : #'accessing - player' }
BigTalkGame >> currentTurnPlayer [

	^ currentPlayer
]

{ #category : #'accessing - deck' }
BigTalkGame >> discardDeckSize [
	^cardController remainingOnDiscardDeck.
]

{ #category : #playing }
BigTalkGame >> drawFromDeck: aPlayer [
	cardController assertDeckNotEmpty.
	aPlayer drawCardFrom: cardController mainDeck 
]

{ #category : #'accessing - finishing' }
BigTalkGame >> hasFinished [

	^ scoreboard hasFinished 
]

{ #category : #initialization }
BigTalkGame >> initializeWithPlayers: somePlayers withDice: someDice withBoard: aBoard finishingAtLap: aLapNumber withDeck: aDeck [

	
	players := somePlayers.
	dice := someDice.
	board := aBoard.
	board addPlayers: somePlayers.
	cardController := GameCardController usingDeck: aDeck onPlayers: somePlayers  .	
	self playersDrawStartingCards.
	lastEffect := NoEffect new.
	scoreboard := Scoreboard competingPlayers: somePlayers finishingAtLap: aLapNumber .
	scoreboard update: board playerPositions.
	turn := SharedQueue new.
	turn nextPutAll: players.
	currentPlayer := turn next
]

{ #category : #'accessing - leader' }
BigTalkGame >> leader [

	^ scoreboard leader key
]

{ #category : #'accessing - leader' }
BigTalkGame >> leaderLap [

	^ scoreboard leaderLap
]

{ #category : #'accessing - leader' }
BigTalkGame >> leaderPosition [

	^ scoreboard leaderPosition
]

{ #category : #playing }
BigTalkGame >> moveCurrentPlayer [

	self assertGameIsNotFinished.
	self playerMoveAfterRoll: self currentTurnPlayer.
	lastEffect := self applyCurrentEffect.
	self changeTurn.
	scoreboard update: board playerPositions
]

{ #category : #'playing - card usage' }
BigTalkGame >> overloadCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Overload new  on: target.
]

{ #category : #private }
BigTalkGame >> player: aPlayer usesCard: aCard on: target [

	self validatePlayabilityOn: aCard by: aPlayer affecting: target.
	aPlayer useCardFromHand: aCard.
	aCard applyOn: self to: target.
	aCard = Redo new
		ifFalse: [ cardController updatedLastCardTo: aCard ]
]

{ #category : #private }
BigTalkGame >> playerMove: aPlayer slots: aNumberOfSlots [

	board movePlayer: aPlayer to: aNumberOfSlots
]

{ #category : #private }
BigTalkGame >> playerMoveAfterRoll: aPlayer [

	| rollvalue modifier |
	modifier := cardController playerRollModifier: aPlayer.
	rollvalue := dice roll + modifier.
	board movePlayer: aPlayer to: rollvalue
]

{ #category : #private }
BigTalkGame >> playerMoveToStart: aPlayer [

	board moveToStart: aPlayer
]

{ #category : #private }
BigTalkGame >> playersDrawStartingCards [

	players do: [ :player | 
		player drawCardFrom: cardController mainDeck.
		player drawCardFrom: cardController mainDeck]
]

{ #category : #'accessing - player' }
BigTalkGame >> rankOf: aPlayer [

	^ scoreboard rankOf: aPlayer
]

{ #category : #'playing - card usage' }
BigTalkGame >> redoCardUsedBy: aPlayer [

self player: aPlayer usesCard: Redo new  on: players.
self addCardToDiscardDeck: Redo new .
]

{ #category : #'playing - card usage' }
BigTalkGame >> redoCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Redo new  on: target.
self addCardToDiscardDeck: Redo new .
]

{ #category : #'effect-application' }
BigTalkGame >> removeActiveCard: aCard from: target [

	cardController removeActiveCard: aCard from: target
]

{ #category : #'playing - card usage' }
BigTalkGame >> repeatCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Repeat new  on: target.
self addCardToDiscardDeck: Repeat new .
]

{ #category : #'playing - card usage' }
BigTalkGame >> speedCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Speed new  on: target.
]

{ #category : #'private - validations' }
BigTalkGame >> validatePlayabilityOn: aCard by: aPlayer affecting: target [

	aCard playableBy: aPlayer on: self affecting: target 
]
