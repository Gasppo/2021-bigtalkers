Class {
	#name : #Redo,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Redo >> applyOn: aGame to: target [

	aGame applyLastCardTo: target
]

{ #category : #'private - validations' }
Redo >> assertLastCardUsedInGame: aGame [
	| carda |
	
	carda := aGame lastCardUsed.
	
	carda ifNil: [ 
		Error signal: 'No available card for Redo' ]
]

{ #category : #'private - validations' }
Redo >> playableBy: aPlayer on: aGame affecting: target [

	self assertLastCardUsedInGame: aGame
]
