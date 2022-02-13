Class {
	#name : #Die,
	#superclass : #Object,
	#instVars : [
		'sides'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
Die class >> assertAtLeastFourSides: aNumberOfSides [

	aNumberOfSides < 4
		ifTrue: [ Error signal: 'Dice have to have at least 4 sides' ]
]

{ #category : #validation }
Die class >> validate: aNumberOfSides [

	self assertAtLeastFourSides: aNumberOfSides
]

{ #category : #'instance creation' }
Die class >> withSides: aNumberOfSides [

	self validate: aNumberOfSides.
	^ self new initializeWith: aNumberOfSides
]

{ #category : #initialization }
Die >> initializeWith: aNumberOfSides [

	sides := aNumberOfSides
]

{ #category : #rolling }
Die >> roll [

	^ (1 to: sides) atRandom
]
