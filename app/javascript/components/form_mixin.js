export const formMixin = (superclass) => class extends superclass {
  #observer
  #handleInput
  #validate
  #formInputs = []
  #value = ''

  closestForm

  static formAssociated = true

  constructor() {
    super()
    this.closestForm = this.closest('form')
    this.internals_ = this.attachInternals()
    this.#validate = ({target, detail: { formSubmission }}) => {
      if (this['required'] && this.#value == '') {
        this.internals_.setValidity({customError: true}, 'This field is required')
        this.setAttribute('error', 'This field is required')
      } else {
        this.internals_.setValidity({})
        this.removeAttribute('error')
      }
      !this.internals_.checkValidity() && formSubmission.stop()
    }

    this.#handleInput = ({ target }) => {
      if (this.parentHost) {
        this.parentHost.dispatchEvent(new Event('component-input'))
      } else {
        this.#value = target.value
        this.internals_.setFormValue(target.value)
      }
    }
  }

  connectedCallback() {
    this.addEventListener('component-input', this.childInput.bind(this))
    super.connectedCallback()
    this.parentHost = this.getRootNode().host
    this.parentHost && (this.closestForm = this.parentHost.closestForm)
    this.startObserver()
    const config = { childList: true, subtree: true };
    this.#observer.observe(this.internals_.shadowRoot, config);
  }

  childInput() {
    // Trick to ensure this execution runs last in the event chain. The WebComponent events need to run first
    setTimeout(() => {
      this.#handleInput({target: this})
    }, 0)
  }

  startObserver() {
    this.#observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.type === 'childList') {
          mutation.addedNodes.forEach((node) => {
            if (node.nodeType === Node.ELEMENT_NODE) {
              this.checkForNewFormElements(node)
            }
          })
        }
      })
    })
  }

  checkForNewFormElements(element) {
    if (element.tagName === 'INPUT' || element.tagName == "SELECT") {
      this.#formInputs.push(element)
      element.addEventListener('input', this.#handleInput)
      element['required'] && this.closestForm.addEventListener('turbo:submit-start', this.#validate)
      this.#handleInput({target: element})
    } else {
      element.querySelectorAll('input, select').forEach((input) => {
        this.#formInputs.push(input)
        input.addEventListener('input', this.#handleInput)
        input['required'] && this.closestForm.addEventListener('turbo:submit-start', this.#validate)
        this.#handleInput({target: input})
      })
    }
  }

  disconnectedCallback () {
    this.removeEventListener('component-input', this.childInput.bind(this))
    if (this.observer) {
      this.observer.disconnect()
      this.observer = null
    }

    this.#formInputs.forEach(input => {
      input.removeEventListener('input', this.#handleInput)
      this.closestForm?.removeEventListener('turbo:submit-start', this.#validate)
    })
  }
}