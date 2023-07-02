import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'output', 'picturePlaceholder', 'textPlaceholder']

  readURL() {
    var input = this.inputTarget
    var output = this.outputTarget
    var picturePlaceholder = this.picturePlaceholderTarget
    var textPlaceholder = this.textPlaceholderTarget

    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function () {
        output.src = reader.result
      }

      reader.readAsDataURL(input.files[0]);

      output.classList.add('d-block');
      picturePlaceholder.classList.add('d-none');
      textPlaceholder.classList.add('d-none');
    }
  }
}
