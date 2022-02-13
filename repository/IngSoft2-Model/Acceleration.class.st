Class {
	#name : #Acceleration,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
Acceleration >> assertIsTurnOf: aPlayer for: aGame [ 

	aGame currentTurnPlayer  ~= aPlayer ifTrue: [ Error
				signal: 'Players can only play permanent cards during their turn' ].
]

{ #category : #initialization }
Acceleration >> initialize [ 
	effect := 1
]

{ #category : #'private - validations' }
Acceleration >> playableBy: aPlayer on: aGame affecting: target [

	self assertIsTurnOf: aPlayer for: aGame 
]
