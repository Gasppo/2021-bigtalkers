Class {
	#name : #LoadedDie,
	#superclass : #Object,
	#instVars : [
		'rollValue'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #validation }
LoadedDie class >> assertRollNotNegative: anExpectedRoll [

	anExpectedRoll negative
		ifTrue: [ Error signal: 'A loaded die cannot have a negative result' ]
]

{ #category : #'instance creation' }
LoadedDie class >> rolling: anExpectedRoll [

	self validate: anExpectedRoll.
	^ self new initializeWith: anExpectedRoll
]

{ #category : #validation }
LoadedDie class >> validate: anExpectedRoll [

	self assertRollNotNegative: anExpectedRoll

]

{ #category : #initialization }
LoadedDie >> initializeWith: anExpectedRoll [
	
	rollValue := anExpectedRoll.
]

{ #category : #rolling }
LoadedDie >> roll [

	^ rollValue
]
