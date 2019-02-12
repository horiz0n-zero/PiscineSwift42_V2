import Foundation

class Deck: NSObject, AllValues {

	var cards: [Card]
	var outs: [Card]
	var discards: [Card]

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
		self.outs = []
		self.discards = []
		super.init()
	}

}

extension Deck {

	func draw() -> Card? {
		if let card = self.cards.first {
			self.cards.removeFirst()
			self.outs.append(card)
			return card
		}
		return nil
	}

	func fold(card: Card) {
		for (index, out) in self.outs.enumerated() { // hashable index(of: ) ??
			if out == card {
				self.discards.append(card)
				self.outs.remove(at: index)
				break
			}
		}
	}

}
