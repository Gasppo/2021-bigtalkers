Class {
	#name : #Repeat,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Repeat >> applyOn: aGame to: aPlayer [

	aGame applyLastEffectTo: aPlayer
]

{ #category : #'private - validations' }
Repeat >> playableBy: aPlayer on: aGame affecting: target [

	^ true
]
