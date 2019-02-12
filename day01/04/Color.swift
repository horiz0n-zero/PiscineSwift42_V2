enum Color: AllValues {
	case pique
	case coeur
	case carreau
	case trefle

	typealias allValuesType = Color

	static let allValues: [allValuesType] = [.pique, .coeur, .carreau, .trefle]
}
