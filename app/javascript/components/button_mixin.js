export const buttonMixin = (superclass) => class extends superclass {

  // Overwriting the component method so that we can keep Turbo enabled
  handleSubmit(e) {
    if (this.submit === undefined) {
      return;
    }
    // eslint-disable-next-line i18next/no-literal-string
    const theForm = this.el.closest('form');
    if (!theForm) {
      return;
    }
    const submitEvent = new CustomEvent('submit', {
      bubbles: true,
      cancelable: true,
      composed: true,
    });
    if (this.submit !== 'skip') {
      theForm.dispatchEvent(submitEvent);
    }
    if (this.submit !== 'prevent') {
      theForm.requestSubmit();
    }
  }
}