Class {
	#name : #Speed,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #asserting }
Speed >> assertIsTurnOf: aPlayer for: aGame [ 

	aGame currentTurnPlayer  ~= aPlayer ifTrue: [ Error
				signal: 'Players can only play permanent cards during their turn' ].
]

{ #category : #asserting }
Speed >> assertOnlyOnePlayerOn: target [

	(target isCollection and: [ target size > 1 ]) ifTrue: [ 
		Error signal: 'This card can only be played on 1 player' ]
]

{ #category : #initialization }
Speed >> initialize [ 
	effect := 1
]

{ #category : #'private - validations' }
Speed >> playableBy: aPlayer on: aGame affecting: target [

	self assertOnlyOnePlayerOn: target.
	self assertIsTurnOf: aPlayer for: aGame.
]
