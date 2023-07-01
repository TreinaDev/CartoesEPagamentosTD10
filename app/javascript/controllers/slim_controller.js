import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    new SlimSelect({
      select: this.element,
      settings: {
        searchText: 'Sem resultados',
        searchPlaceholder: 'Busque por uma regra de cashback',
        allowDeselect: true,
        hideSelected: true
      }
    })
  }
}
