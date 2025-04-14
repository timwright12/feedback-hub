import {buttonMixin} from "./button_mixin";
import {formMixin} from "./form_mixin";
import {
  VaButton,
  VaDate,
  VaSelect,
  defineCustomElementVaTable,
  VaTextarea,
  VaTextInput
} from '@department-of-veterans-affairs/component-library/dist/components'

defineCustomElementVaTable()

customElements.define("va-text-area", formMixin(VaTextarea))
customElements.define("va-button", buttonMixin(VaButton))
customElements.define("va-date", formMixin(VaDate))
customElements.define("va-select", formMixin(VaSelect))
customElements.define("va-text-input", formMixin(VaTextInput))