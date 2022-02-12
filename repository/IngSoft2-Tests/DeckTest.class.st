Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DeckTest >> testDeckAddCards [
	| aDeck eventsDistribution| 
	eventsDistribution := OrderedCollection new.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: Acceleration new havingProbability: 1).
		
	aDeck := Deck withProbabilities: eventsDistribution usingCardAmount: 2.
	self assert: aDeck cardsRemaining equals: 2.
	aDeck addCard: Acceleration new.
	self assert: aDeck cardsRemaining equals: 3.
]

{ #category : #tests }
DeckTest >> testDeckRemoveByDrawingCards [
	| aDeck eventsDistribution card1 card2| 
	eventsDistribution := OrderedCollection new.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: Acceleration new havingProbability: 1).
		
	aDeck := Deck withProbabilities: eventsDistribution usingCardAmount: 2.
	card1 := aDeck drawWithoutReposition.
	self assert: aDeck cardsRemaining equals: 1.
	card2 := aDeck drawWithoutReposition.
	self assert: aDeck cardsRemaining equals: 0.
]

{ #category : #tests }
DeckTest >> testDeckStartsEmpty [
	| aDeck eventsDistribution| 
	eventsDistribution := OrderedCollection new.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: Acceleration new havingProbability: 1).
		
	aDeck := Deck withProbabilities: eventsDistribution usingCardAmount: 0.
	
	^self assert: aDeck cardsRemaining equals: 0.
]
