struct Card {

	var color: Color
	var value: Value

	init(color: Color, value: Value) {
		self.color = color
		self.value = value
	}

	static func ==(lhs: Card, rhs: Card) -> Bool {
		return lhs.color == rhs.color && lhs.value == rhs.value
	}

}
