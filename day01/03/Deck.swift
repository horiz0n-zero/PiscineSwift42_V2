import Foundation

class Deck: NSObject, AllValues {

	var cards: [Card]

	typealias allValuesType = Card

	static let allValues: [allValuesType] = {
		var array = [Card]()

		for color in Color.allValues {
			for value in Value.allValues {
				let card = Card.init(color: color, value: value)

				array.append(card)
			}
		}
		return array
	}()

	init(random: Bool) {
		if random {
			self.cards = Deck.allValues//.shuffled()
		}
		else {
			self.cards = Deck.allValues
		}
		super.init()
	}

}
