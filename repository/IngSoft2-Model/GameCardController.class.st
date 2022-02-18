Class {
	#name : #GameCardController,
	#superclass : #Object,
	#instVars : [
		'activeCards',
		'lastCardUsed',
		'mainDeck',
		'discardDeck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
GameCardController class >> usingDeck: aDeck onPlayers: somePlayers [

	^self new initializeWithDeck: aDeck withPlayers: somePlayers
]

{ #category : #accessing }
GameCardController >> activeCardStack [ 
	^activeCards 
]

{ #category : #'adding/removing' }
GameCardController >> addActiveCard: aCard on: target [

	target isCollection
		ifTrue: [ target do: [ :player | activeCards add: aCard to: player ] ]
		ifFalse: [ activeCards add: aCard to: target ]
]

{ #category : #'adding/removing' }
GameCardController >> addToDiscardDeck: aCard [
	discardDeck addCard: aCard.
]

{ #category : #assertions }
GameCardController >> assertDeckNotEmpty [

	mainDeck cardsRemaining > 0 ifFalse: [ self assertDiscardDeckNotEmpty ]
]

{ #category : #assertions }
GameCardController >> assertDiscardDeckNotEmpty [

	discardDeck cardsRemaining > 0
		ifTrue: [ self rebuildDeck ]
		ifFalse: [ 
			Error signal:
				'Cant draw from empty deck, and discard deck is empty' ]
]

{ #category : #modifying }
GameCardController >> boost: aCard from: target [

	activeCards boost: aCard from: target
]

{ #category : #initialization }
GameCardController >> initializeWithDeck: aDeck withPlayers: somePlayers [

	mainDeck := aDeck.
	discardDeck := Deck empty.
	activeCards := ActiveCardController forPlayers: somePlayers.
]

{ #category : #accessing }
GameCardController >> lastCardUsed [
	^lastCardUsed.
]

{ #category : #accessing }
GameCardController >> mainDeck [
	
	^mainDeck 
]

{ #category : #accessing }
GameCardController >> playerRollModifier: aPlayer [

	^activeCards playerRollModifier: aPlayer.
]

{ #category : #modifying }
GameCardController >> rebuildDeck [

	mainDeck := discardDeck shuffled.
	discardDeck := Deck empty
]

{ #category : #accessing }
GameCardController >> remainingOnDiscardDeck [

	^mainDeck cardsRemaining.
]

{ #category : #accessing }
GameCardController >> remainingOnMainDeck [

	^mainDeck cardsRemaining.
]

{ #category : #'adding/removing' }
GameCardController >> removeActiveCard: aCard from: target [
	
	activeCards remove: aCard from: target 
]

{ #category : #'adding/removing' }
GameCardController >> updatedLastCardTo: aCard [

	lastCardUsed := aCard.
]
