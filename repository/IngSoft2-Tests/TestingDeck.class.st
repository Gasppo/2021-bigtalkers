Class {
	#name : #TestingDeck,
	#superclass : #Deck,
	#category : #'IngSoft2-Tests'
}

{ #category : #'instance creation' }
TestingDeck class >> onlyAccelerationCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Acceleration new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]

{ #category : #'instance creation' }
TestingDeck class >> onlyCancellationCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Cancellation new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]

{ #category : #'instance creation' }
TestingDeck class >> onlyOverloadCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Overload new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]

{ #category : #'instance creation' }
TestingDeck class >> onlyRedoCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Redo new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]

{ #category : #'instance creation' }
TestingDeck class >> onlyRepeatCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Repeat new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]

{ #category : #'instance creation' }
TestingDeck class >> onlySpeedCards [

	| eventsDistribution cardDistribution generator |
	eventsDistribution := OrderedCollection new.
	eventsDistribution add:
		(DiscreteProbabilityEvent of: Speed new havingProbability: 1).

	cardDistribution := OrderedCollection new.
	generator := DistributionItemGenerator basedOn: eventsDistribution.


	1 to: 100 do: [ :index | cardDistribution add: generator generate ].

	^ self new initializeWith: cardDistribution
]
