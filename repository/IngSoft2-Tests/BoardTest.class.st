Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#instVars : [
		'effects'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #assertions }
BoardTest >> should: anErrorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: anErrorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
BoardTest >> testBoardCannotBeCreatedWithZeroSlots [

	self
		should: [ Board sizedWithNoEffects: 0 ]
		raise: Error
		withMessage: 'Boards need at least one slot'
]

{ #category : #tests }
BoardTest >> testBoardSlotGeneratorGeneratesSlot [

	|slotToUse eventsDistribution generator boardSlot|
	eventsDistribution := OrderedCollection new.
	slotToUse := BoardSlot withMoonwalkWithTwoStepsBack.
	eventsDistribution
		add: (DiscreteProbabilityEvent of: slotToUse havingProbability: 1).
	generator := DistributionItemGenerator basedOn: eventsDistribution.
	boardSlot := generator generate.
	self assert: (boardSlot effect) equals: (slotToUse effect)
]

{ #category : #tests }
BoardTest >> testDiscreteProbabilityEventCannotHaveNegativeProbabilites [

	self
		should: [ DiscreteProbabilityEvent of: BoardSlot withNoEffect havingProbability: -0.38 ]
		raise: Error
		withMessage: 'Probabilities must be positive'
]
