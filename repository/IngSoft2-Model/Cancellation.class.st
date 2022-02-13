Class {
	#name : #Cancellation,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Cancellation >> applyOn: aGame to: target [

	| cancelledCard player |
	cancelledCard := target at: 1.
	player := target at: 2.
	aGame removeActiveCard: cancelledCard from: player
]

{ #category : #assertions }
Cancellation >> assertActiveCardsAvailable: aGame [

	aGame activeCardStack isEmpty ifTrue: [ 
		Error signal: 'Cant play cancellation with no active cards in game' ]
]

{ #category : #'private - validations' }
Cancellation >> playableBy: aPlayer on: aGame affecting: target [
	
	self assertActiveCardsAvailable: aGame
]
