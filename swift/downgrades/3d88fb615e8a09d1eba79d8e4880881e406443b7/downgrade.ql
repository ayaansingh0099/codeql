class Element extends @element {
  string toString() { none() }
}

predicate removedClass(Element e, string name, Element child) {
  unsafe_cast_exprs(e) and
  name = "UnsafeCastExpr" and
  implicit_conversion_exprs(e, child)
}

query predicate new_unspecified_elements(Element e, string property, string error) {
  unspecified_elements(e, property, error)
  or
  exists(string name |
    removedClass(e, name, _) and
    property = "" and
    error = name + " nodes removed during database downgrade. Please update your CodeQL code."
  )
}

query predicate new_unspecified_element_children(Element e, int index, Element child) {
  unspecified_element_children(e, index, child)
  or
  removedClass(e, _, child) and index = 0
}

query predicate new_implicit_conversion_exprs(Element e, Element child) {
  implicit_conversion_exprs(e, child) and not removedClass(e, _, _)
}

query predicate new_expr_types(Element e, Element type) {
  expr_types(e, type) and not removedClass(e, _, _)
}
