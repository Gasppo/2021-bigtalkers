Class {
	#name : #Overload,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
Overload >> assertIsTurnOf: aPlayer for: aGame [ 

	aGame currentTurnPlayer  ~= aPlayer ifTrue: [ Error
				signal: 'Players can only play permanent cards during their turn' ].
]

{ #category : #assertions }
Overload >> assertOnlyOnePlayerOn: target [

	(target isCollection and: [ target size > 1 ]) ifTrue: [ 
		Error signal: 'This card can only be played on 1 player' ]
]

{ #category : #initialization }
Overload >> initialize [ 
	effect := -2
]

{ #category : #'private - validations' }
Overload >> playableBy: aPlayer on: aGame affecting: target [

	self assertOnlyOnePlayerOn: target.
	self assertIsTurnOf: aPlayer for: aGame.
]
