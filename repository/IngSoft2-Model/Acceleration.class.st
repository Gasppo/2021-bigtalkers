Class {
	#name : #Acceleration,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
Acceleration >> initialize [ 
	effect := 1
]

{ #category : #'private - validations' }
Acceleration >> playableBy: aPlayer on: aGame affecting: target [

	aGame currentTurnPlayer  ~= aPlayer ifTrue: [ Error
				signal: 'Players can only play permanent cards during their turn' ].
]
