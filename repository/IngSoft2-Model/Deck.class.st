Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Deck class >> default [

	^ self new
		initializeWith:
			{Speed new.
			Acceleration new.
			Redo new.
			Repeat new.
			Overload new.
			Cancellation new}
]

{ #category : #'instance creation' }
Deck class >> empty [

	^ self new initializeWith: {  }
]

{ #category : #'instance creation' }
Deck class >> withProbabilities: eventsDistribution usingCardAmount: amountOfCards [

	| cardDistribution generator|
	
	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.
	
	1 to: amountOfCards do: [ :index | cardDistribution add: (generator generate) ].
	^ self new initializeWith: cardDistribution
]

{ #category : #drawing }
Deck >> addCard: aCard [
	
	cards add: aCard.
]

{ #category : #drawing }
Deck >> cardsRemaining [

	^ cards size
]

{ #category : #drawing }
Deck >> drawWithoutReposition [

	| drawnCard |
	drawnCard := cards removeLast.
	^ drawnCard
]

{ #category : #initialization }
Deck >> initializeWith: aCardCollection [
	
	cards := OrderedCollection withAll: aCardCollection
]

{ #category : #drawing }
Deck >> shuffled [

	cards := cards shuffled
]
