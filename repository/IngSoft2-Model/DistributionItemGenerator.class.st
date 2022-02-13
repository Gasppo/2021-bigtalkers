Class {
	#name : #DistributionItemGenerator,
	#superclass : #Object,
	#instVars : [
		'randomness',
		'eventsPool'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
DistributionItemGenerator class >> assertTotalProbabilityEqualsOne: eventsDistribution [

	| probabilities totalProbability |
	probabilities := eventsDistribution
		collect: [ :event | event probability ].
	totalProbability := probabilities
		inject: 0
		into: [ :sum :each | sum + each ].
	totalProbability = 1
		ifFalse: [ Error signal: 'All probabilities must sum 1' ]
]

{ #category : #'instance creation' }
DistributionItemGenerator class >> basedOn: eventsDistribution [

	self validate: eventsDistribution.
	^ self new initializeWith: eventsDistribution.
]

{ #category : #validation }
DistributionItemGenerator class >> validate: eventsDistribution [

	self assertTotalProbabilityEqualsOne: eventsDistribution
]

{ #category : #generating }
DistributionItemGenerator >> generate [

	| events |
	events := OrderedCollection new.
	^ eventsPool atRandom: randomness
]

{ #category : #initialization }
DistributionItemGenerator >> initializeWith: eventsDistribution [

	randomness := Random new.
	eventsPool := OrderedCollection new.
	eventsDistribution
		do: [ :probabilityEvent | 
			eventsPool
				add: probabilityEvent event
				withOccurrences: (probabilityEvent probability * 100) asInteger ]
]
