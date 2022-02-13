Class {
	#name : #Boost,
	#superclass : #Instant,
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Boost >> applyOn: aGame to: target [

	| boostedCard player |
	boostedCard := target at: 1.
	player := target at: 2.
	aGame boostActiveCard: boostedCard from: player
]

{ #category : #'private - validations' }
Boost >> playableBy: aPlayer on: aGame affecting: target [
	
	aGame activeCardStack isEmpty ifTrue: [ Error signal: 'Cant play boost with no active cards in game' ]
]
