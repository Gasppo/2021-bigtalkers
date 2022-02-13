Class {
	#name : #Dice,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
Dice class >> assertUsingAtLeastOneDie: someDice [

	someDice isEmpty
		ifTrue: [ Error signal: 'Dice need to have at least one Die' ]
]

{ #category : #validation }
Dice class >> validate: someDice [

	self assertUsingAtLeastOneDie: someDice
]

{ #category : #'instance creation' }
Dice class >> with: someDice [

	self validate: someDice.
	^ self new initializeWith: someDice
]

{ #category : #initialization }
Dice >> initializeWith: aDiceCollection [

	dice := aDiceCollection
]

{ #category : #rolling }
Dice >> roll [

	^ dice sum: [ :die | die roll ]
]
