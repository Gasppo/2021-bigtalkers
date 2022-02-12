Class {
	#name : #ItemGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'player1',
		'player2',
		'player3'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
ItemGeneratorTest >> should: anErrorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
ItemGeneratorTest >> testItemGeneratorGeneratesDeck [
	| aDeck eventsDistribution| 
	eventsDistribution := OrderedCollection new.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: Acceleration new havingProbability: 1).
		
	aDeck := Deck withProbabilities: eventsDistribution usingCardAmount: 0.
	
	^self assert: (aDeck cardsRemaining) equals: 0.
]

{ #category : #tests }
ItemGeneratorTest >> testItemGeneratorNeedsProbabilitySumOfOne [

	| eventsDistribution |
	eventsDistribution := OrderedCollection new.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: BoardSlot withNoEffect havingProbability: 0.38);
		add: (DiscreteProbabilityEvent of: BoardSlot withSpeedUp havingProbability: 0.2);
		add: (DiscreteProbabilityEvent of: BoardSlot withWormHole havingProbability: 0.2);
		add: (DiscreteProbabilityEvent of: BoardSlot withMoonwalkWithTwoStepsBack havingProbability: 0.3);
		add: (DiscreteProbabilityEvent of: BoardSlot withAtomicBomb havingProbability: 0.02);
		add: (DiscreteProbabilityEvent of: BoardSlot withGrabCard havingProbability: 0.10).
	self
		should: [ DistributionItemGenerator basedOn: eventsDistribution ]
		raise: Error
		withMessage: 'All probabilities must sum 1'
]
