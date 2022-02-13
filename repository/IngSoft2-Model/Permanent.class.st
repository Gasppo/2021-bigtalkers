Class {
	#name : #Permanent,
	#superclass : #Card,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Permanent >> applyOn: aGame to: target [
	
	aGame addActiveCard: self on: target 
	
]

{ #category : #'private - validations' }
Permanent >> boost [

	effect := effect * 2
]

{ #category : #'accessing - effect' }
Permanent >> effect [

	^ effect
]

{ #category : #'private - validations' }
Permanent >> playableBy: aPlayer on: aGame affecting: target [

	^ self subclassResponsibility 
]
