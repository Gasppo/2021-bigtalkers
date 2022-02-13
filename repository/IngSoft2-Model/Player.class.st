Class {
	#name : #Player,
	#superclass : #Object,
	#instVars : [
		'name',
		'hand'
	],
	#classInstVars : [
		'position'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #assertions }
Player class >> assertNotEmptyName: aName [

	aName = ''
		ifTrue: [ Error signal: 'A player cannot have an empty name' ]
]

{ #category : #'instance creation' }
Player class >> named: aName [

	self validate: aName.
	^ self new initializeWith: aName
]

{ #category : #validation }
Player class >> validate: aName [

	self assertNotEmptyName: aName
]

{ #category : #'private - accessing' }
Player >> assertDeckNotEmpty: aDeck [
	
 aDeck cardsRemaining > 0 ifFalse: [ Error signal: 'Cant draw from empty deck' ]
]

{ #category : #'private - accessing' }
Player >> drawCardFrom: aDeck [

	| newCard |
	self assertDeckNotEmpty: aDeck.
	newCard := aDeck drawWithoutReposition .
	hand add: newCard
]

{ #category : #initialization }
Player >> initializeWith: aName [
	
	hand := OrderedCollection new.
	name := aName
]

{ #category : #'accessing - name' }
Player >> playerName [

	^ name
]

{ #category : #'accessing - cards' }
Player >> useCardFromHand: aCard [

	hand remove: aCard ifAbsent: [ 
		hand isEmpty
			ifTrue: [ Error signal: 'The player does not have any cards left' ]
			ifFalse: [ Error signal: 'The player does not have that card' ] ]
]
